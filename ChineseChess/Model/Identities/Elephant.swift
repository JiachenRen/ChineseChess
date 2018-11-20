//
//  Elephant.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Elephant: Piece {
    override func availableMoves(_ board: Board) -> [Pos] {
        var moves = [Pos]()
        let pos = self.pos
        let add = {(i, q) in moves.append(pos + Pos(i, q))}
        add(2 , 2)
        add(2 , -2)
        add(-2 , -2)
        add(-2 , 2)
        let isUpperHalf = pos.row <= 4
        basicFilter(&moves, board)
        return moves.filter{$0.isValid()}.filter {
            // The Elephant cannot cross the river.
            return isUpperHalf ? $0.row <= 4 : $0.row >= 5
        }
    }
}
