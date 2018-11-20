//
//  King.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class King: Piece {
    var cands: [Pos] {
        return [Pos(0, 1), Pos(1, 0), Pos(0, -1), Pos(-1, 0)]
    }
    override func availableMoves() -> [Pos] {
        var moves = [Pos]()
        cands.forEach {
            let p = pos + $0
            if pos.inLowerPalace && p.inLowerPalace || pos.inUpperPalace && p.inUpperPalace {
                moves.append(p)
            }
        }
        return moves
    }
}
