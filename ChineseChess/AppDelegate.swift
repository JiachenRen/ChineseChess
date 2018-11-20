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
    
    var windowControllers = [BoardWindowController]()

    @IBAction func undo(_ sender: NSMenuItem) {
        activeGameState?.undo()
    }
    
    @IBAction func redo(_ sender: NSMenuItem) {
        activeGameState?.redo()
    }
    
    @IBAction func restart(_ sender: NSMenuItem) {
        activeGameState?.restart()
    }
    
    @IBAction func save(_ sender: NSMenuItem) {
        activeWController?.save()
    }
    
    @IBAction func open(_ sender: NSMenuItem) {
        BoardWindowController.open() {
            self.windowControllers.append(contentsOf: $0)
        }
    }
    
    
    
    @IBAction func new(_ sender: NSMenuItem) {
        let bwc = NSStoryboard(name: "Main", bundle: nil)
                .instantiateController(withIdentifier: "board_window_controller") as! BoardWindowController
        windowControllers.append(bwc)
        bwc.showWindow(self)
        
        // Window stacking animation
        if NSApplication.shared.orderedWindows.count >= 2 {
            let frame = NSApplication.shared.orderedWindows[1].frame
                let newFrame = CGRect(
                    x: frame.minX + 10,
                    y: frame.minY - 10,
                    width: frame.width,
                    height: frame.height)
                bwc.window?.setFrame(newFrame, display: true, animate: true)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

// Getters for quick access
extension AppDelegate {
    
    var activeWController: BoardWindowController? {
        return NSApplication.shared.mainWindow?.windowController as? BoardWindowController
    }
    
    var activeController: BoardViewController? {
        return activeWController?.contentViewController as? BoardViewController
    }
    
    var activeGameState: GameState? {
        return activeController?.gameState
    }
    
    var activeBoard: Board? {
        return activeController?.board
    }
}
