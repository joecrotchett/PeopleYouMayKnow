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
    
    func getPeopleYouMayKnow(completion: @escaping (Result<[Person], APIError>) -> Void) {
        api.getPeople { result in
            switch result {
            case .success(let people):
                let graph = self.constructGraph(from: people)
                let groups = self.groupBySocialDistance(graph: graph)
                let pymk = Array(groups.joined())
                completion(.success(pymk))

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
        var distance = 2 // Skip over the user group, and the users's friends group
        while let group = nodeGroups[distance] {
            var people = group.map { $0.person }
            if distance == 2 {
                people = people.sorted(by: { lhs, rhs -> Bool in
                    return lhs.mutualCount ?? -1 > rhs.mutualCount ?? -1
                })
            }
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
                }
            }
        }
        
        return breadthFirstSearchShortestPath(graph: graph, source: userNode)
    }
    
    private func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
        let shortestPathGraph = graph.duplicate()
        
        var queue = Queue()
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
                
                // At each level of the tree, determine the number of mutual connections
                // to the neightbor nodes. This number is only used for people who are
                // friends of friends, but the algorithm is cleaner, and it's just as
                // performant to set this for everyone.
                if neighborNode.distance! > current.distance! {
                    neighborNode.increaseMutualFriendCount()
                }
                
                print("Current -> \(current)")
                print("Neighbor -> \(neighborNode)")
            }
        }
        
        return shortestPathGraph
    }
}

