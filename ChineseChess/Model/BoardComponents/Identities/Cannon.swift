//
//  Cannon.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Cannon: Car {
    override func explore(row: Int, col: Int) -> [Pos] {
        var pos = self.pos
        var moves = [Pos]()
        var barbette: Piece?
        while true {
            pos.row += row
            pos.col += col
            
            if pos.isValid() {
                if let p = board.get(pos) {
                    if barbette == nil {
                        barbette = p
                    } else {
                        if p.color != color {
                            moves.append(pos)
                        }
                        break
                    }
                } else {
                    if barbette == nil {
                        moves.append(pos)
                    }
                }
            } else {
                break
            }
        }
        return moves
    }
}
