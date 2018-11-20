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
        let add = {(i: Int, q: Int) -> Void in
            let eye = pos + Pos(i / 2, q / 2)
            if eye.isValid() && board.get(eye) == nil {
                moves.append(pos + Pos(i, q))
            }
        }
        add(2 , 2)
        add(2 , -2)
        add(-2 , -2)
        add(-2 , 2)
        return moves.filter {
            // The Elephant cannot cross the river.
            return pos.isUpperhalf == $0.isUpperhalf
        }
    }
}
