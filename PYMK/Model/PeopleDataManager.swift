//
//  PeopleDataManager.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

final class PeopleDataManager {
    
    let userName = "Facebook Candidate"
    
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
    func getPeopleGroupedBySocialDistance(completion: @escaping (Result<[[Person]], APIError>) -> Void) {
        api.getPeople { result in
            switch result {
            case .success(let people):
                let groups = self.groupBySocialDistance(people: people)
                completion(.success(groups))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func groupBySocialDistance(people: [Person]) -> [[Person]] {
        let graph = self.constructGraph(from: people)
        guard let nodeGroups = graph?.nodesGroupedByDistance else { return [] }
        
        var groupsByDistance = [[Person]]()
        var distance = 1
        while let group = nodeGroups[distance] {
            let people = group.map { $0.person }
            groupsByDistance.append(people)
            distance += 1
        }
        
        return groupsByDistance
    }
    
    private func constructGraph(from people: [Person]) -> Graph? {
        let user = people.first(where: { $0.name ==  userName})
        let others = people.filter({ $0.name != userName })
        
        guard let user = user, !others.isEmpty else {
            return nil
        }
        
        let graph = Graph()
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
}

