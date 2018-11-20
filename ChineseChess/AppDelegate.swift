//
//  AppDelegate.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/17/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    var activeController: BoardViewController? {
        return NSApplication.shared.mainWindow?.windowController?.contentViewController as? BoardViewController
    }
    
    var activeGameState: GameState? {
        return activeController?.gameState
    }
    
    var activeBoard: Board? {
        return activeController?.board
    }

    @IBAction func undo(_ sender: NSMenuItem) {
        activeGameState?.undo()
    }
    
    @IBAction func redo(_ sender: NSMenuItem) {
        activeGameState?.redo()
    }
    
    @IBAction func restart(_ sender: NSMenuItem) {
        activeGameState?.restart()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

