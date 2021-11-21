//
//  Graph.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Graph: CustomStringConvertible, Equatable {
    private(set) var nodes: [Node]
    
    init() {
        self.nodes = []
    }
    
    @discardableResult
    func addNode(person: Person) -> Node {
        let node = Node(person: person)
        nodes.append(node)
        return node
    }
    
    func addEdge(_ source: Node, neighbor: Node) {
        let edge = Edge(neighbor: neighbor)
        source.neighbors.append(edge)
    }
    
    var description: String {
        var description = ""
        
        for node in nodes {
            if !node.neighbors.isEmpty {
                description += "[node: \(node) edges: \(node.neighbors.map { $0.neighbor.person.name})]"
            }
        }
        return description
    }
    
    func findNode(with id: Int) -> Node {
        return nodes.filter { $0.person.id == id }.first!
    }
    
    func duplicate() -> Graph {
        let duplicated = Graph()
        
        for node in nodes {
            duplicated.addNode(person: node.person)
        }
        
        for node in nodes {
            for edge in node.neighbors {
                let source = duplicated.findNode(with: node.person.id)
                let neighbour = duplicated.findNode(with: edge.neighbor.person.id)
                duplicated.addEdge(source, neighbor: neighbour)
            }
        }
        
        return duplicated
    }
    
    var nodesGroupedByDistance: [Int: [Node]] {
        Dictionary.init(grouping: nodes, by: { $0.distance ?? 0 })
    }
}

func == (lhs: Graph, rhs: Graph) -> Bool {
    return lhs.nodes == rhs.nodes
}
