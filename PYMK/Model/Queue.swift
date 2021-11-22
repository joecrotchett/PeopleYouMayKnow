//
//  Queue.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

struct Queue {
    private var array: [Vertex]
    
    init() {
        array = []
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    mutating func enqueue(element: Vertex) {
        array.append(element)
    }
    
    mutating func dequeue() -> Vertex? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
}
