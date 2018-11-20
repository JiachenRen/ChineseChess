//
//  Car.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Car: Piece {
    func explore(row: Int, col: Int) -> [Pos] {
        var pos = self.pos
        var moves = [Pos]()
        while true {
            pos.row += row
            pos.col += col
            
            if pos.isValid() {
                if let p = board.get(pos) {
                    if p.color != color { // Eat 'em!
                        moves.append(pos)
                    }
                    break
                } else {
                    moves.append(pos)
                }
            } else {
                break
            }
        }
        return moves
    }
    
    override func availableMoves() -> [Pos] {
        var moves = [Pos]()
        moves.append(contentsOf: explore(row: 1, col: 0))
        moves.append(contentsOf: explore(row: 0, col: 1))
        moves.append(contentsOf: explore(row: -1, col: 0))
        moves.append(contentsOf: explore(row: 0, col: -1))
        return moves
    }
}
