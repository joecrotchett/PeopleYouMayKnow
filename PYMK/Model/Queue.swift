//
//  Queue.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

struct Queue {
    private var array: [Node]
    
    init() {
        array = []
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func enqueue(element: Node) {
        array.append(element)
    }
    
    mutating func dequeue() -> Node? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    // Not used
    func peek() -> Node? {
        return array.first
    }
}
