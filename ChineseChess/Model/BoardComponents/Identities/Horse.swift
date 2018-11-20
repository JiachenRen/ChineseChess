//
//  Horse.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Horse: Piece {
    override func availableMoves() -> [Pos] {
        var moves = [Pos]()
        let pos = self.pos
        let board = self.board!
        [Pos(2, 1), Pos(2, -1), Pos(-2, 1), Pos(-2, -1), Pos(1, -2), Pos(-1, -2), Pos(1, 2), Pos(-1, 2)].forEach {
            let offset = abs($0.row) > abs($0.col) ? Pos($0.row / 2, 0) : Pos(0, $0.col / 2)
            let foot = pos + offset
            if foot.isValid() && board.get(foot) == nil {
                moves.append(pos + $0)
            }
        }
        return moves
    }
}
