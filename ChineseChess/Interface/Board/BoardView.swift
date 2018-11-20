//
//  BoardView.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Cocoa

@IBDesignable class BoardView: NSView, NSAnimationDelegate {

    @IBInspectable var boardColor: NSColor = .white
    @IBInspectable var gridColor: NSColor = .black
    
    @IBInspectable var pieceColor: NSColor = .white
    
    @IBInspectable var redColor: NSColor = .red
    @IBInspectable var blackColor: NSColor = .black
    
    @IBInspectable var pieceScale: CGFloat = 0.8
    
    var gridLineWidth: CGFloat {
        return gap / 20
    }
    
    var pieceRadius: CGFloat {
        return gap / 2 * pieceScale
    }
    
    var boardWidth: CGFloat {
        return bounds.width - cornerOffset * 2
    }
    
    var gap: CGFloat {
        return bounds.width / 9.5
    }
    
    var cornerOffset: CGFloat {
        return (bounds.width - gap * 8) / 2
    }
    
    var corner: CGPoint {
        return .init(x: cornerOffset, y: cornerOffset)
    }
    
    var cgContext: CGContext? {
        return NSGraphicsContext.current?.cgContext
    }
    
    var delegate: BoardViewDelegate?
    var mouseDownPos: Pos?
    var selected: Piece? {
        didSet {
            shouldAnimate = true
            setNeedsDisplay(bounds)
        }
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.wantsLayer = true
        
        // Fill board background
        boardColor.setFill()
        NSBezierPath(rect: bounds).fill()
        
        drawGrid()
        drawPieces()
    }
    
    private func drawPieces() {
        let board = Board()
        board.stream.forEach{ piece in
            let ellipse = NSBezierPath(ovalIn: rect(at: piece.pos))
            pieceColor.setFill()
            ellipse.lineWidth = gridLineWidth
            ellipse.fill()
            
            let color = piece.color == .black ? blackColor : redColor
            color.setStroke()
            ellipse.stroke()
            
            if shouldAnimate {
                shouldAnimate = false
                let animation = NSAnimation(duration: 0.15, animationCurve: .easeInOut)
                animation.animationBlockingMode = .nonblocking
                animation.delegate = self
                animation.progressMarks = stride(from: 0, to: 1, by: 0.05)
                    .map{NSNumber(value: $0)}
                animation.start()
            }
            
            if let s = selected, s.pos == piece.pos {
                func animateEllipse(_ scale: CGFloat) {
                    let r = CGRect(center: onScreen(s.pos), size: CGSize(width: scale, height: scale))
                    let e = NSBezierPath(ovalIn: r)
                    color.withAlphaComponent(progress * 0.5).setStroke()
                    e.lineWidth = gridLineWidth * 2
                    e.stroke()
                }
                animateEllipse(pieceRadius * 2 * (1.7 - 0.7 * progress))
                animateEllipse(pieceRadius * 2 * (0.3 + 0.7 * progress))
            }
            
            // Draw Chinese character at the center
            drawCharOverlay(for: piece)
        }
    }
    var shouldAnimate = false
    var progress: CGFloat = 0
    func animation(_ animation: NSAnimation, didReachProgressMark progress: NSAnimation.Progress) {
        if let pos = selected?.pos {
            self.progress = CGFloat(progress)
            let l = pieceRadius * 2 * 2 + gridLineWidth * 2
            let invalid = CGRect(center: onScreen(pos), size: CGSize(width: l, height: l))
            setNeedsDisplay(invalid)
        }
    }
    
    private func drawCharOverlay(for piece: Piece) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let color = piece.color == .black ? blackColor : redColor
        let char = piece.identity.rawValue
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle  : paragraphStyle,
            NSAttributedString.Key.font            : NSFont.systemFont(ofSize: pieceRadius),
            NSAttributedString.Key.baselineOffset  : 0,
            NSAttributedString.Key.foregroundColor : color
            ] as [NSAttributedString.Key : Any]
        var ctr = onScreen(piece.pos)
        ctr.y += pieceRadius / 8
        let textRect = CGRect(center: ctr, size: CGSize(width: pieceRadius * 2, height: pieceRadius))
        let attrString = NSAttributedString(string: "\(char)", attributes: attributes)
        attrString.draw(with: textRect, options: .usesFontLeading)
    }
    
    func rect(at pos: Pos) -> CGRect {
        return CGRect(center: onScreen(pos),
                      size: CGSize(width: pieceRadius * 2, height: pieceRadius * 2))
    }
    
    /// Convert a Pos on board to coordinates on screen
    func onScreen(_ pos: Pos) -> CGPoint {
        return CGPoint(
            x: cornerOffset + CGFloat(pos.col) * gap,
            y: bounds.height - (cornerOffset + CGFloat(pos.row) * gap)
        )
    }
    

    /// Convert coordinates on screen to Pos on board
    func onBoard(_ onScreen: CGPoint) -> Pos {
        func convert(_ n: CGFloat) -> Int {
            return Int((n - cornerOffset) / gap + 0.5)
        }
        return Pos(10 - convert(onScreen.y) - 1, convert(onScreen.x))
    }
    
    override func mouseDown(with event: NSEvent) {
        let loc = relPos(evt: event)
        if loc.x <= 0 || loc.y <= 0 {return}
        mouseDownPos = onBoard(loc)
    }
    
    override func mouseUp(with event: NSEvent) {
        let loc = relPos(evt: event)
        if loc.x <= 0 || loc.y <= 0 {return}
        if let l = mouseDownPos {
            if let p = delegate?.board.get(l), l == onBoard(loc) {
                if p.color == delegate?.board.curPlayer {
                    delegate?.didSelect(l)
                    selected = p
                }
            }
        }
    }
    
    /**
     Convert the absolute position of the mouse to relative coordinate within the bounds
     - Returns: position of the mouse within bounds
     */
    private func relPos(evt: NSEvent) -> CGPoint {
        let absPos = evt.locationInWindow
        return CGPoint(x: absPos.x - frame.minX, y: absPos.y - frame.minY)
    }
    
    
    private func drawGrid() {
        if let ctx = NSGraphicsContext.current?.cgContext {
            ctx.saveGState()
            ctx.setLineWidth(gridLineWidth)
            ctx.setStrokeColor(gridColor.cgColor)
            ctx.setLineCap(.square)
            ctx.setAlpha(0.8)
            
            // Horizontal lines
            for i in 0..<10 {
                line(from: Pos(i, 0), to: Pos(i, 8))
            }
            
            // Vertical lines
            for i in 0..<9 {
                line(from: Pos(0, i), to: Pos(4, i))
                line(from: Pos(5, i), to: Pos(9, i))
            }
            
            // Diagnoal lines
            var p1 = Pos(0, 3), p2 = Pos(2, 5)
            line(from: p1, to: p2)
            line(from: p1.invertCol(), to: p2.invertCol())
            p1 = p1.invertRow()
            p2 = p2.invertRow()
            line(from: p1, to: p2)
            line(from: p1.invertCol(), to: p2.invertCol())
            
            
            // Draw board rectangle
            ctx.translateBy(x: cornerOffset, y: cornerOffset)
            let boardRect = NSRect(origin: corner.translating(0, gridLineWidth), size: .init(width: gap * 8, height: gap * 9))
            let path = NSBezierPath(rect: boardRect)
            ctx.setAlpha(1)
            path.lineWidth = gridLineWidth * 1.5
            path.stroke()
            ctx.restoreGState()
            
//            // Draw diagnoal lines
//            ctx.setLineWidth(gridLineWidth)
//            ctx.setStrokeColor(gridColor.cgColor)
//            ctx.setLineCap(.square)
//            ctx.setAlpha(0.5)
//            line(from: Pos(0, 3), to: Pos(2,5))
        }
    }
    
    private func line(from pos1: Pos, to pos2: Pos) {
        cgContext?.strokeLineSegments(between: [onScreen(pos1), onScreen(pos2)])
    }
}

protocol BoardViewDelegate {
    var board: Board {get}
    func didSelect(_ pos: Pos)
}

extension CGPoint {
    func translating(_ x: CGFloat, _ y: CGFloat) -> CGPoint{
        return CGPoint(x: x, y: y)
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize){
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
    static func fillCircle(center: CGPoint, radius: CGFloat) {
        let circle = NSBezierPath(ovalIn: CGRect(center: center, size: CGSize(width: radius * 2, height: radius * 2)))
        circle.fill()
    }
}
