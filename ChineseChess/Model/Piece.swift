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
    
    func next() -> Color {
        return self == .black ? .red : .black
    }
}

enum Identity: String {
    case horse = "马"
    case elephant = "象"
    case king = "将"
    case `guard` = "士"
    case pawn = "卒"
    case car = "车"
    case cannon = "炮"
    
    func spawn(_ color: Color) -> Piece {
        switch self {
        case .horse: return Horse(self, color)
        case .elephant: return Elephant(self, color)
        case .king: return King(self, color)
        case .guard: return Guard(self, color)
        case .pawn: return Pawn(self, color)
        case .car: return Car(self, color)
        case .cannon: return Cannon(self, color)
        }
    }
}

protocol PieceProtocol {
    var identity: Identity {get}
    var color: Color {get}
    var pos: Pos {get set}
}

class Piece: PieceProtocol {
    let identity: Identity
    let color: Color
    var pos: Pos = Pos(0, 0)
    
    init(_ identity: Identity, _ color: Color) {
        self.identity = identity
        self.color = color
    }
    
    func copy() -> Piece {
        return identity.spawn(color)
    }
}
