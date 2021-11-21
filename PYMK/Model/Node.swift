//
//  Node.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Node: CustomStringConvertible, Equatable {
    var neighbors: [Edge]
    
    private(set) var person: Person
    var distance: Int?
    var visited: Bool
    
    init(person: Person) {
        self.person = person
        neighbors = []
        visited = false
    }
    
    var description: String {
        if let distance = distance {
            return "Node(name: \(person.name), distance: \(distance))"
        }
        return "Node(name: \(person.name), distance: infinity)"
    }
    
    var hasDistance: Bool {
        return distance != nil
    }
    
    func remove(edge: Edge) {
        neighbors.remove(at: neighbors.firstIndex { $0 === edge }!)
    }
    
    func markAsFriend() {
        person.isFriendOfUser = true
    }
}

func == (lhs: Node, rhs: Node) -> Bool {
    return lhs.person.id == rhs.person.id && lhs.neighbors == rhs.neighbors
}
