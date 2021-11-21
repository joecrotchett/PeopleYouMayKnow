//
//  Graph.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

public class Graph: CustomStringConvertible, Equatable {
  public private(set) var nodes: [Node]

  public init() {
    self.nodes = []
  }

  @discardableResult
  public func addNode(id: Int) -> Node {
    let node = Node(id: id)
    nodes.append(node)
    return node
  }

  public func addEdge(_ source: Node, neighbor: Node) {
    let edge = Edge(neighbor: neighbor)
    source.neighbors.append(edge)
  }

  public var description: String {
    var description = ""

    for node in nodes {
      if !node.neighbors.isEmpty {
        description += "[node: \(node.id) edges: \(node.neighbors.map { $0.neighbor.id})]"
      }
    }
    return description
  }

  public func findNode(with id: Int) -> Node {
    return nodes.filter { $0.id == id }.first!
  }

  public func duplicate() -> Graph {
    let duplicated = Graph()

    for node in nodes {
      duplicated.addNode(id: node.id)
    }

    for node in nodes {
      for edge in node.neighbors {
        let source = duplicated.findNode(with: node.id)
        let neighbour = duplicated.findNode(with: edge.neighbor.id)
        duplicated.addEdge(source, neighbor: neighbour)
      }
    }

    return duplicated
  }
}

public func == (lhs: Graph, rhs: Graph) -> Bool {
  return lhs.nodes == rhs.nodes
}
