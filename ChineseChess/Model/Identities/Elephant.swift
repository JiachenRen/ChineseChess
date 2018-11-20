//
//  Elephant.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Elephant: Piece {
    override func availableMoves() -> [Pos] {
        var moves = [Pos]()
        let pos = self.pos
        let board = self.board!
        [Pos(2, 2), Pos(2, -2), Pos(-2, -2), Pos(-2, 2)].forEach {
            let eye = pos + Pos($0.row / 2, $0.col / 2)
            if eye.isValid() && board.get(eye) == nil {
                moves.append(pos + $0)
            }
        }
        return moves.filter {
            // The Elephant cannot cross the river.
            return pos.isUpperhalf == $0.isUpperhalf
        }
    }
}
