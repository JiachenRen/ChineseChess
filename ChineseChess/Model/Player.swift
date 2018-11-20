//
//  Player.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

protocol Player {
    func getMove()
}

extension Player {
    
    // Empty implementation
    func getMove() {}
}

class ComputerPlayer: Player {
    var delegate: PlayerDelegate!
    var color: Color
    
    init(playAs color: Color) {
        self.color = color
    }
}

protocol PlayerDelegate {
    func makeMove(move: Move)
}
