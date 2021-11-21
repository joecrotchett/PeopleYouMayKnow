//
//  PeopleDataManager.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

/**
I'm using the `Repository` pattern here to hide away the details of how the search result
data is retrieved. For this app, it's not absolutely necessary, since we're only pulling
data from the API, and in this case, a json file,  but it's still a good pattern to have in place in the event that we
wanted to introduce other data access objects, like persisting data in a local data store, for example.
*/

final class PeopleDataManager {
    
    private let api: PeopleAPI
    private var pymk = [[Person]]()
    
    init(api: PeopleAPI) {
        self.api = api
    }
    
    func getPeopleGroupedBySocialDistance(completion: @escaping (Result<[[Person]], APIError>) -> Void) {
        api.getPeople { result in
            switch result {
            case .success(let people):
                let graph = self.constructGraph(from: people)
                let groups = self.groupBySocialDistance(graph: graph)
                completion(.success(groups))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Private
    
    private func groupBySocialDistance(graph: Graph) -> [[Person]] {
        let nodeGroups = graph.nodesGroupedByDistance
        
        // Convert the dictionary of groupings into an array of groupings to
        // make it easier for the tableview datasource to undestand the groupings
        var peopleGroups = [[Person]]()
        var distance = 1 // Skip over the user group, and the users's friends group
        while let group = nodeGroups[distance] {
            let people = group.map { $0.person }
//            if distance == 2, let friendNodes = nodeGroups[1] {
//                let friends = friendNodes.map { $0.person }
//                let mutualConnections = mutualConnections(friends: friends, others: people)
//                groupsByDistance.append(mutualConnections)
//            } else {
//                groupsByDistance.append(people)
//            }
            
            peopleGroups.append(people)
            distance += 1
        }
        
        return peopleGroups
    }
    
    private func constructGraph(from people: [Person]) -> Graph {
        let graph = Graph()
        let user = people.first(where: { $0.isUser})
        let others = people.filter({ !$0.isUser })
        
        guard let user = user, !others.isEmpty else {
            return graph
        }
        
        var nodes = [Int: Node]()
        let userNode = graph.addNode(person: user)
        nodes[user.id] = userNode
        
        for person in others {
            nodes[person.id] = graph.addNode(person: person)
        }
        
        for person in people {
            let personNode = nodes[person.id]
            for friend in person.friends {
                if let friendNode = nodes[friend], let personNode = personNode {
                    graph.addEdge(personNode, neighbor: friendNode)
                    if personNode == userNode {
                        friendNode.markAsFriend()
                    }
                }
            }
        }

        return breadthFirstSearchShortestPath(graph: graph, source: userNode)
    }
    
    private func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
      let shortestPathGraph = graph.duplicate()

      var queue = Queue<Node>()
      let sourceInShortestPathsGraph = shortestPathGraph.findNode(with: source.person.id)
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
    
//    private func mutualConnections(friends: [Person], others: [Person]) -> [Person] {
//        for person in others {
//
//        }
//    }
}

