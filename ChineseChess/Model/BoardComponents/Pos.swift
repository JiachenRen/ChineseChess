//
//  Pos.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/20/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

struct Pos: Hashable, Serializable {
    var row: Int
    var col: Int
    
    var isUpperhalf: Bool {
        return row <= 4
    }
    
    var inUpperPalace: Bool {
        return row >= 0 && row <= 2 && col <= 5 && col >= 3
    }
    
    var inLowerPalace: Bool {
        return row >= 7 && row <= 9 && col <= 5 && col >= 3
    }
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    init(_ encoded: String) {
        let pair = encoded.split(separator: ",")
            .map{Int($0)!}
        row = pair.first!
        col = pair.last!
    }
    
    func serialize() -> String {
        return "\(row),\(col)"
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
