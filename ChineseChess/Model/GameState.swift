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
    var selected: Piece?
    var board = Board()
    
    func enroll(_ player: Player, as color: Color) {
        players.updateValue(player, forKey: color)
    }
    
    func restart() {
        board = Board()
        delegate?.gameStateDidUpdate()
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
    
    func redo() {
        board.redo()
        delegate?.gameStateDidUpdate()
    }
    
    func undo() {
        board.undo()
        delegate?.gameStateDidUpdate()
    }
    
    func getAvailableMoves(for piece: Piece) -> [Move] {
        return piece.availableMoves(board)
            .map{Move(piece.pos, $0, board.get($0))}
    }
    
    func makeMove(_ move: Move) {
        board.makeMove(move)
        requestMove() // Allow the next player to make a move
        delegate?.gameStateDidUpdate()
    }
}

protocol GameStateDelegate {
    func gameStateDidUpdate()
}
