//
//  BoardWindowController.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/20/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Cocoa

class BoardWindowController: NSWindowController {
    
    var board: Board {
        return viewController.board
    }
    
    var gameState: GameState {
        return viewController.gameState
    }
    
    static let openPanel: NSOpenPanel = {
        let panel = NSOpenPanel(contentRect: .zero, styleMask: .fullSizeContentView, backing: .buffered, defer: true)
        panel.canChooseDirectories = false
        panel.allowedFileTypes = ["xq"]
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        return panel
    }()
    
    var viewController: BoardViewController {
        return window!.contentViewController as! BoardViewController
    }
    
    var fileName = "New Game" {
        didSet {
            window?.title = fileName
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.title = fileName
    }
    
    static func open(_ completion: (([BoardWindowController]) -> Void)? = nil) {
        var controllers = [BoardWindowController]()
        
        openPanel.begin() { response in
            switch response {
            case .OK:
                var curFrame = NSApplication.shared.mainWindow?.frame ?? CGRect.zero
                for url in openPanel.urls {
                    curFrame.origin = CGPoint(x: curFrame.minX + 10, y: curFrame.minY - 10)
                    let bwc = NSStoryboard(name: "Main", bundle: nil)
                        .instantiateController(withIdentifier: "board_window_controller") as! BoardWindowController
                    do {
                        let game = try String(contentsOf: url, encoding: .utf8)
                        let fileName = url.lastPathComponent
                        let idx = fileName.firstIndex(of: ".")!
                        bwc.fileName = String(fileName[..<idx]) // Update the name of the window
                        bwc.gameState.load(game)
                        bwc.showWindow(self)
                        if curFrame.size == .zero {
                            curFrame = bwc.window!.frame
                        } else {
                            bwc.window?.setFrame(curFrame, display: true, animate: true)
                        }
                        controllers.append(bwc)
                    } catch let err {
                        print(err)
                    }
                }
                completion?(controllers)
            default: break
            }
        }
    }
    
    func save() {
        if board.history.stack.isEmpty {
            let _ = dialogue(msg: "Cannot save empty game.", infoTxt: "Give me some juice!")
            return
        }
        print("Saving...")
        let panel = NSSavePanel(contentRect: contentViewController!.view.bounds, styleMask: .fullSizeContentView, backing: .buffered, defer: true)
        panel.allowedFileTypes = ["xq"]
        panel.delegate = self
        if let window = self.window {
            panel.nameFieldStringValue = fileName
            panel.beginSheetModal(for: window) {response in
                switch response {
                case .OK:
                    self.fileName = panel.nameFieldStringValue
                default: break
                }
            }
        }
    }
    
}

extension BoardWindowController: NSOpenSavePanelDelegate {
    func panel(_ sender: Any, validate url: URL) throws {
        do {
            print("Saving to \(url)")
            let game = board.serialize()
            try game.write(to: url, atomically: true, encoding: .utf8)
        } catch let err {
            print(err)
        }
    }
}

func dialogue(msg: String, infoTxt: String) -> Bool {
    let alert: NSAlert = NSAlert()
    alert.messageText = msg
    alert.informativeText = infoTxt
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    let res = alert.runModal()
    if res == .alertFirstButtonReturn {
        return true
    }
    return false
}
