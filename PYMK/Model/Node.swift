//
//  Node.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

public class Node: CustomStringConvertible, Equatable {
  public var neighbors: [Edge]

  public private(set) var id: Int
  public var distance: Int?
  public var visited: Bool

  public init(id: Int) {
    self.id = id
    neighbors = []
    visited = false
  }

  public var description: String {
    if let distance = distance {
      return "Node(label: \(id), distance: \(distance))"
    }
    return "Node(label: \(id), distance: infinity)"
  }

  public var hasDistance: Bool {
    return distance != nil
  }

  public func remove(edge: Edge) {
      neighbors.remove(at: neighbors.firstIndex { $0 === edge }!)
  }
}

public func == (lhs: Node, rhs: Node) -> Bool {
  return lhs.id == rhs.id && lhs.neighbors == rhs.neighbors
}
