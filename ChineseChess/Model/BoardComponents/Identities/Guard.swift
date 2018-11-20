//
//  Guard.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class Guard: King {
    override var cands: [Pos] {
        return [Pos(1, 1), Pos(1, -1), Pos(-1, 1), Pos(-1, -1)]
    }
}
