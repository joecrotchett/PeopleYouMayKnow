//
//  Edge.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Edge: Equatable {
    var neighbor: Vertex
    
    init(neighbor: Vertex) {
        self.neighbor = neighbor
    }
}

func == (lhs: Edge, rhs: Edge) -> Bool {
    return lhs.neighbor == rhs.neighbor
}
