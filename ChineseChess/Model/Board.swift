//
//  Board.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Board {
    var matrix = [[Piece?]]()
    var history: History<Move>
    var curPlayer: Color
    
    // Since the initial layout in Chinese Chess is symmetrical in all quadrants,
    // we only need to specify the layout for one quadrant; the rest could be derived.
    static let initLayout: Dictionary<Pos, Identity> = [
        Pos(0, 0): .car,
        Pos(0, 1): .horse,
        Pos(0, 2): .elephant,
        Pos(0, 3): .guard,
        Pos(0, 4): .king,
        Pos(3, 4): .pawn,
        Pos(3, 0): .pawn,
        Pos(2, 1): .cannon,
        Pos(3, 2): .pawn
    ]
    
    // Stream available pieces
    var stream: [Piece] {
        return matrix.flatMap{$0}
            .filter{$0 != nil}
            .map{$0!}
    }
    
    init(other: Board) {
        matrix = other.matrix
        history = History(other.history)
        curPlayer = other.curPlayer
    }
    
    init() {
        history = History<Move>()
        curPlayer = .red // Is the first player black or red?
        applyInitialLayout()
    }
    
    private func applyInitialLayout() {
        matrix = [[Piece?]](repeating: [Piece?](repeating: nil, count: 9), count: 10)
        
        // Apply symmetrical layout to all quadrants
        Board.initLayout.forEach { pair in
            let (pos, identity) = pair
            let blackPiece = identity.spawn(.black)
            let redPiece = identity.spawn(.red)
            
            set(pos, blackPiece) // Black LL
            set(pos.invertCol(), blackPiece.copy()) // Black LR
            
            let rPos = pos.invertRow()
            set(rPos, redPiece) // Red UL
            set(rPos.invertCol(), redPiece.copy()) // Right UR
        }
        
        // Assign position to each piece
        for r in 0..<matrix.count {
            for c in 0..<matrix[0].count {
                if let p = matrix[r][c] {
                    p.pos = Pos(r, c)
                }
            }
        }
    }
    
    /**
     - Note: Does not check if the move is a legal move, simply performs the move.
     - Parameters:
        - target: The position of the piece to be moved
        - dest: Where to put the designated piece.
     - Returns: The piece been eaten as a result of the move (if applicable)
     */
    @discardableResult
    func move(_ target: Pos, to dest: Pos, recordHistory: Bool = true) -> Piece? {
        guard let piece = matrix[target.row][target.col] else {
            fatalError()
        }
        set(target, nil)
        let eat = get(dest)
        set(dest, piece)
        curPlayer = curPlayer.next()
        
        if recordHistory {
            let mv = Move(target, dest, eat)
            history.push(mv)
        }
        
        return eat
    }
    
    func makeMove(_ move: Move) {
        self.move(move.origin, to: move.dest)
    }
    
    /**
     Redo last move
     */
    func redo() {
        if let mv = history.restore() {
            move(mv.origin, to: mv.dest, recordHistory: false)
        }
    }
    
    /**
     Undo last move
     */
    func undo() {
        if let mv = history.revert() {
            // Undo the move
            move(mv.dest, to: mv.origin, recordHistory: false)
            
            // Put the eaten piece back into its original position
            set(mv.dest, mv.eat)
        }
    }
    
    func set(_ pos: Pos, _ piece: Piece?) {
        matrix[pos.row][pos.col] = piece
        piece?.pos = pos
    }
    
    func get(_ pos: Pos) -> Piece? {
        return matrix[pos.row][pos.col]
    }
}

class History<Element> {
    var stack: [Element]
    var reverted: [Element]
    
    init() {
        stack = [Element]()
        reverted = [Element]()
    }
    
    init(_ other: History) {
        stack = other.stack
        reverted = other.reverted
    }
    
    /**
     Push a move into the history stack
     */
    func push(_ element: Element) {
        stack.append(element)
        reverted = [Element]() // Clear the history that's been overwritten
    }
    
    /**
     Used for reverting a move
     Extract a move from the history stack
     */
    func revert() -> Element? {
        if stack.count == 0 {return nil}
        let top = stack.removeLast()
        reverted.append(top)
        return top
    }
    
    /**
     Used for restoring a reverted move
     */
    func restore() -> Element? {
        if reverted.count == 0 {return nil}
        let top = reverted.removeLast()
        stack.append(top)
        return top
    }
}

struct Move {
    let origin: Pos
    let dest: Pos
    let eat: Piece?
    
    init(_ from: Pos, _ to: Pos, _ eat: Piece?) {
        self.origin = from
        self.dest = to
        self.eat = eat
    }
}

struct Pos: Hashable {
    var row: Int
    var col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    func isValid() -> Bool {
        return row <= 9 && row >= 0 && col <= 8 && col >= 0
    }
    
    func translateBy(row: Int) -> Pos {
        return Pos(self.row + row, col)
    }
    
    func translateBy(col: Int) -> Pos {
        return Pos(row, self.col + col)
    }
    
    func translateBy(row: Int, col: Int) -> Pos {
        return Pos(self.row + row, self.col + col)
    }
    
    func invertRow() -> Pos {
        return Pos(9 - row, col)
    }
    
    func invertCol() -> Pos {
        return Pos(row, 8 - col)
    }
    
    static func +(lhs: Pos, rhs: Pos) -> Pos {
        return Pos(lhs.row + rhs.row, lhs.col + rhs.col)
    }
    
    static func -(lhs: Pos, rhs: Pos) -> Pos {
        return Pos(lhs.row - rhs.row, lhs.col - rhs.col)
    }
}




