//
//  ViewController.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Cocoa

class BoardViewController: NSViewController {
    
    
    @IBOutlet weak var boardView: BoardView!
    var gameState = GameState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameState.delegate = self
        boardView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension BoardViewController: BoardViewDelegate {
    var board: Board {
        return gameState.board
    }
    
    func didSelect(_ pos: Pos) {
        print("selected: \(pos)")
    }
}

extension BoardViewController: GameStateDelegate {
    
    func gameStateDidUpdate() {
        
    }
}
