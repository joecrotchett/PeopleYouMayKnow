//
//  Graph.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Graph: Equatable {
    private(set) var vertices = [Vertex]()
    
    @discardableResult
    func addVertex(person: Person) -> Vertex {
        let vertex = Vertex(person: person)
        vertices.append(vertex)
        return vertex
    }
    
    func addEdge(_ source: Vertex, neighbor: Vertex) {
        let edge = Edge(neighbor: neighbor)
        source.neighbors.append(edge)
    }
    
    func findVertex(with id: Int) -> Vertex? {
        return vertices.filter { $0.person.id == id }.first
    }
    
    func duplicate() -> Graph {
        let duplicated = Graph()
        
        for vertex in vertices {
            duplicated.addVertex(person: vertex.person)
        }
        
        for vertex in vertices {
            for edge in vertex.neighbors {
                if let source = duplicated.findVertex(with: vertex.person.id),
                   let neighbour = duplicated.findVertex(with: edge.neighbor.person.id) {
                    duplicated.addEdge(source, neighbor: neighbour)
                }
            }
        }
        
        return duplicated
    }
    
    var verticesGroupedByDistance: [Int: [Vertex]] {
        Dictionary.init(grouping: vertices, by: { $0.distance ?? 0 })
    }
}

func == (lhs: Graph, rhs: Graph) -> Bool {
    return lhs.vertices == rhs.vertices
}
