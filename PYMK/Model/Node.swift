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
    var distance: Int? {
        didSet {
            person.distance = distance
        }
    }
    var visited: Bool
    
    init(person: Person) {
        self.person = person
        neighbors = []
        visited = false
    }
    
    var description: String {
        if let distance = distance {
            return "Node(name: \(person.name), distance: \(distance), mutualCount: \(person.mutualCount ?? -1)"
        }
        return "Node(name: \(person.name), distance: infinity)"
    }
    
    var hasDistance: Bool {
        return distance != nil
    }
    
    func remove(edge: Edge) {
        neighbors.remove(at: neighbors.firstIndex { $0 === edge }!)
    }
    
    func increaseMutualFriendCount() {
        guard let count = person.mutualCount else {
            person.mutualCount = 1
            return
        }
        
        person.mutualCount = count + 1
    }
}

func == (lhs: Node, rhs: Node) -> Bool {
    return lhs.person.id == rhs.person.id && lhs.neighbors == rhs.neighbors
}
