//
//  Piece.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation


enum Color {
    case black
    case red
}

enum Identity: String {
    case horse = "马"
    case elephant = "象"
    case king = "将"
    case `guard` = "士"
    case pawn = "卒"
    case car = "车"
    case cannon = "炮"
}

protocol PieceProtocol {
    var identity: Identity {get set}
    var color: Color {get set}
}

class Piece: PieceProtocol {
    var identity: Identity
    var color: Color
    
    init(_ identity: Identity, _ color: Color) {
        self.identity = identity
        self.color = color
    }
}
