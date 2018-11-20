//
//  BoardView.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Cocoa

@IBDesignable class BoardView: NSView {

    @IBInspectable var pieceColor: NSColor = .white
    @IBInspectable var boardColor: NSColor = .white
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
            
            // Draw Chinese character at the center
            drawCharOverlay(for: piece)
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
    
    /**
     Convert a coordinate to position on screen
     */
    func onScreen(_ pos: Pos) -> CGPoint {
        return CGPoint(
            x: cornerOffset + CGFloat(pos.col) * gap,
            y: bounds.height - (cornerOffset + CGFloat(pos.row) * gap)
        )
    }
    
    private func drawGrid() {
        if let ctx = NSGraphicsContext.current?.cgContext {
            ctx.saveGState()
            ctx.translateBy(x: cornerOffset, y: cornerOffset)
            ctx.setLineWidth(gridLineWidth)
            ctx.setStrokeColor(.black)
            ctx.setLineCap(.square)
            ctx.setAlpha(0.5)
            
            // Draw 10 horizontal lines
            ctx.saveGState()
            for _ in 0..<10 {
                ctx.strokeLineSegments(between: [.zero, CGPoint.zero.translating(boardWidth, 0)])
                ctx.translateBy(x: 0, y: gap)
            }
            ctx.restoreGState()
            
            // Draw 9 vertical lines broken in two halves.
            ctx.saveGState()
            for _ in 0..<9 {
                ctx.strokeLineSegments(between: [.zero, CGPoint.zero.translating(0, gap * 4)])
                ctx.strokeLineSegments(between: [
                    CGPoint.zero.translating(0, gap * 9),
                    CGPoint.zero.translating(0, gap * 5)])
                ctx.translateBy(x: gap, y: 0)
            }
            ctx.restoreGState()
            
            // Draw board rectangle
            let boardRect = NSRect(origin: .zero, size: .init(width: gap * 8, height: gap * 9))
            let path = NSBezierPath(rect: boardRect)
            path.lineWidth = gridLineWidth * 1.5
            path.stroke()
            ctx.restoreGState()
        }
    }
    
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
