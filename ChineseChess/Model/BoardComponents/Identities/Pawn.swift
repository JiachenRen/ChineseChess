//
//  Pawn.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

/// Red is always on the bottom half of the board
class Pawn: Piece {
    override func availableMoves() -> [Pos] {
        let i = color == .black ? 1 : -1
        if color == .black ? pos.isUpperhalf : !pos.isUpperhalf  { // If not promoted
            return [pos + Pos(i, 0)]
        } else { // If promoted
            // Sorry, but you can't go backwards
            return [Pos(i, 0), Pos(0, -1), Pos(0, 1)]
                .map{$0 + pos}
        }
    }
}
