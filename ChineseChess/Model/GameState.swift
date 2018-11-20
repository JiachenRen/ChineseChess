//
//  GameState.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/19/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

class GameState: PlayerDelegate {
    var players = Dictionary<Color, Player>()
    var curPlayer: Player? {
        return players[board.curPlayer]
    }
    var delegate: GameStateDelegate?
    var board = Board()
    
    func enroll(_ player: Player, as color: Color) {
        players.updateValue(player, forKey: color)
    }
    
    func restart() {
        board = Board()
    }
    
    /**
     Request the current player to make a move.
     */
    func requestMove() {
        if let player = curPlayer {
            player.getMove()
        }
    }
    
    func begin() {
        requestMove()
    }
    
    func makeMove(move: Move) {
        board.makeMove(move)
        requestMove() // Allow the next player to make a move
        delegate?.gameStateDidUpdate()
    }
}

protocol GameStateDelegate {
    func gameStateDidUpdate()
}
