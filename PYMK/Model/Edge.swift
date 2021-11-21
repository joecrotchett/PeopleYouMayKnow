//
//  Edge.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

class Edge: Equatable {
  var neighbor: Node

  init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

func == (lhs: Edge, rhs: Edge) -> Bool {
  return lhs.neighbor == rhs.neighbor
}
