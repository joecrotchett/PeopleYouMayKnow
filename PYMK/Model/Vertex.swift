//
//  vertex.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Vertex: Equatable {
    var neighbors: [Edge]
    
    private(set) var person: Person
    var distance: Int? {
        didSet {
            person.distance = distance
        }
    }
    
    init(person: Person) {
        self.person = person
        neighbors = []
    }
    
    var hasDistance: Bool {
        return distance != nil
    }
    
    func increaseMutualFriendCount() {
        guard let count = person.mutualCount else {
            person.mutualCount = 1
            return
        }
        
        person.mutualCount = count + 1
    }
}

func == (lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.person.id == rhs.person.id && lhs.neighbors == rhs.neighbors
}
