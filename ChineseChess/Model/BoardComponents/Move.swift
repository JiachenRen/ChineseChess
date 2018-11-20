//
//  Move.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/20/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

struct Move: Serializable {
    let origin: Pos
    let dest: Pos
    let eat: Piece?
    
    init(_ from: Pos, _ to: Pos, _ eat: Piece?) {
        self.origin = from
        self.dest = to
        self.eat = eat
    }
    
    init(_ encoded: String) {
        let pair = encoded.components(separatedBy: "->")
            .map{Pos($0)}
        origin = pair.first!
        dest = pair.last!
        eat = nil
    }
    
    func serialize() -> String {
        return "\(origin.serialize())->\(dest.serialize())"
    }
}
