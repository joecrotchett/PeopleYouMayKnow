//
//  PeopleDataManager.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

final class PeopleDataManager {
    
    private let api: PeopleAPI
    private var pymk = [[Person]]()
    
    init(api: PeopleAPI) {
        self.api = api
    }
    
    /**
    I'm using the `Repository` pattern here to hide away the details of how the search result
    data is retrieved. For this app, it's not absolutely necessary, since we're only pulling
    data from the API, and in this case, a json file,  but it's still a good pattern to have in place in the event that we
    wanted to introduce other data access objects, like persisting data in a local data store, for example.
    */
    func getPeople(completion: @escaping (Result<[Person], APIError>) -> Void) {
        api.getPeople { result in
            switch result {
            case .success(let people):
                completion(.success(people))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func constructGraph(from people: [Person]) {
        let graph = Graph()
        
        var nodes = [Int: Node]()
        for person in people {
            nodes[person.id] = graph.addNode(id: person.id)
        }
        
        for person in people {
            let personNode = nodes[person.id]
            for friend in person.friends {
                if let friendNode = nodes[friend], let personNode = personNode {
                    graph.addEdge(personNode, neighbor: friendNode)
                }
            }
        }

//        let nodeA = graph.addNode(id: 1)
//        let nodeB = graph.addNode(id: 2)
//        let nodeC = graph.addNode(id: 3)
//        let nodeD = graph.addNode(id: 4)
//        let nodeE = graph.addNode(id: 5)
//        let nodeF = graph.addNode(id: 6)
//        let nodeG = graph.addNode(id: 7)
//        let nodeH = graph.addNode(id: 8)
//
//        graph.addEdge(nodeA, neighbor: nodeB)
//        graph.addEdge(nodeA, neighbor: nodeC)
//        graph.addEdge(nodeB, neighbor: nodeD)
//        graph.addEdge(nodeB, neighbor: nodeA)
//        graph.addEdge(nodeB, neighbor: nodeE)
//        graph.addEdge(nodeC, neighbor: nodeF)
//        graph.addEdge(nodeC, neighbor: nodeG)
//        graph.addEdge(nodeE, neighbor: nodeH)

//        let shortestPathGraph = breadthFirstSearchShortestPath(graph: graph, source: nodeA)
//        print(shortestPathGraph.nodes)
    }
    
    private func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
      let shortestPathGraph = graph.duplicate()

      var queue = Queue<Node>()
      let sourceInShortestPathsGraph = shortestPathGraph.findNode(with: source.id)
      queue.enqueue(element: sourceInShortestPathsGraph)
      sourceInShortestPathsGraph.distance = 0

      while let current = queue.dequeue() {
        for edge in current.neighbors {
          let neighborNode = edge.neighbor
          if !neighborNode.hasDistance {
            queue.enqueue(element: neighborNode)
            neighborNode.distance = current.distance! + 1
          }
        }
      }

      return shortestPathGraph
    }

    
    
//    func findEdges(for knowns: [Person], from unknowns: [Person]) {
//        var edgesFound = false
//        guard list.count > 0 else {
//            return
//        }
//        
//        var found: [People]()
//        var remaining
//        
//        for unknown in unknowns {
//            for known in knowns {
//                for unknownFriend in unknown.friends {
//                    if unknownFriend == known.id {
//                        
//                    }
//                }
//            }
//        }
//        
//        return
//    }
}

