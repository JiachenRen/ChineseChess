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
    
    // Since the initial layout in Chinese Chess is symmetrical in all quadrants,
    // we only need to specify the layout for one quadrant; the rest could be derived.
    static var initLayout: Dictionary<Pos, Identity> = [
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
    
    var stream: [(pos: Pos, piece: Piece)] {
        var pieces = [(Pos, Piece)]()
        for r in 0..<matrix.count {
            for c in 0..<matrix[0].count {
                if let p = matrix[r][c] {
                    let element = (Pos(r, c), p)
                    pieces.append(element)
                }
            }
        }
        return pieces
    }
    
    init() {
        applyInitialLayout()
    }
    
    func set(_ pos: Pos, _ piece: Piece?) {
        matrix[pos.row][pos.col] = piece
    }
    
    func applyInitialLayout() {
        matrix = [[Piece?]](repeating: [Piece?](repeating: nil, count: 9), count: 10)
        
        // Apply symmetrical layout to all quadrants
        Board.initLayout.forEach { pair in
            let (pos, identity) = pair
            let blackPiece = Piece(identity, .black)
            let redPiece = Piece(identity, .red)
            
            set(pos, blackPiece) // Black LL
            set(pos.invertCol(), blackPiece) // Black LR
            
            let rPos = pos.invertRow()
            set(rPos, redPiece) // Red UL
            set(rPos.invertCol(), redPiece) // Right UR
        }
    }
}

struct Pos: Hashable {
    var row: Int
    var col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
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
}
