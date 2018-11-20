//
//  History.swift
//  ChineseChess
//
//  Created by Jiachen Ren on 11/20/18.
//  Copyright © 2018 Jiachen Ren. All rights reserved.
//

import Foundation

protocol Serializable {
    func serialize() -> String
    init(_ encoded: String)
}

class History<Element: Serializable> {
    var stack: [Element]
    var reverted: [Element]
    
    init() {
        stack = [Element]()
        reverted = [Element]()
    }
    
    init(_ other: History) {
        stack = other.stack
        reverted = other.reverted
    }
    
    required convenience init(_ encoded: String) {
        self.init()
        stack = encoded.split(separator: ";")
            .map{Element(String($0))}
    }
    
    /**
     Push a move into the history stack
     */
    func push(_ element: Element) {
        stack.append(element)
        reverted = [Element]() // Clear the history that's been overwritten
    }
    
    /**
     Used for reverting a move
     Extract a move from the history stack
     */
    func revert() -> Element? {
        if stack.count == 0 {return nil}
        let top = stack.removeLast()
        reverted.append(top)
        return top
    }
    
    /**
     Used for restoring a reverted move
     */
    func restore() -> Element? {
        if reverted.count == 0 {return nil}
        let top = reverted.removeLast()
        stack.append(top)
        return top
    }
}

extension History: Serializable {
    func serialize() -> String {
        var str =  stack.map{$0.serialize()}
            .reduce(""){"\($0);\($1)"}
        str.removeFirst()
        return str
    }
}
