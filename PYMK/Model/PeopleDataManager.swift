//
//  PeopleDataManager.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

/**
I'm using the `Repository` pattern here to hide away the details of how the PYMK
data is retrieved. For this app, it's not absolutely necessary, since we're only pulling data
from the API, and in this case, a json file,  but it's still a good pattern to have in place in the event that we
wanted to introduce other data access objects, like persisting data in a local data store, for example.
*/

final class PeopleDataManager {
    
    private let api: PeopleAPI
    private var pymk = [[Person]]()
    
    init(api: PeopleAPI) {
        self.api = api
    }
    
    // MARK: Public Interface
    
    /**
     Description of algorithm
     -----------------
     To generate the list of relationships between the people, with the lowest degree of separation between
     each person in the graph, I'm using an Adjacency List to represent the graph of relationships between
     friends, and I'm using Breadth First Search to generate a graph that represents the shortest distance
     from the Meta candidate,to every other person in the graph. Once the shortest path graph is generated,
     I'm using a dictionary to group each person by their distance, and then I use IntroSort to sort the friends
     of friends by their number of mutual friends.The total time complexity for the algorithm is O(n log n).
     
     Runtime analytics for construct person graph: `O(n) + O(n) + O(n) + O(m) == O(n + m), n = person count, m = total number of friendships
     --------------------------------
     1) Find candidate user in person list: O(n)
     2) Create list representing all other persons: O(n)
     3) Add vertices for each person in the list: O(n)
     4) Add edges between people and their friends: O(m)
     
     Runtime analytics for constructing short path graph: `O(n) + O(n) + O(n) + O(m) == O(n + m), n = person count, m = total number of friendships
     --------------------------------
     1) Duplicate relationship graph: O(n)
     2) Find source vertex: O(n)
     3) Generate shortest path graph: O(n+m)
     
     Runtime analysis for generating the list of people, sorted by social distance, and mutual friendships: `O(n) + O(n log n) + O(n)== O(n logn)
     ----------------------------------------------------------------------
     1) Group people by their distance from the Meta candidate: O(n)
     2) Sort friends of friends by their number of mutual friendships: O(n log n)
     3) Flatten groupings into one list: O(n)
     
     `Total time complexity: O(n + m) + O(n + m) + O(n logn) == O(n log n)
    */
    
    /**
     Retrieves the list of Person objects from the API, constructs the person graph, and generates the list of
     people you may know.
    */
    func getPeopleYouMayKnow(completion: @escaping (Result<[Person], APIError>) -> Void) {
        api.getPeople { result in
            switch result {
            case .success(let people):
                let graph = self.constructPeopleGraph(from: people)
                let pymk = self.generatePYMKList(from: graph)
                completion(.success(pymk))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Private
    
    /**
     Generates the list of people, sorted by social distance, and mutual friendships
    */
    private func generatePYMKList(from graph: Graph) -> [Person] {
        // Generate the adjacency list as a dictionary of vertex lists by distance
        let vertexGroups = graph.verticesGroupedByDistance
        
        // Convert the dictionary of groupings into an array of groupings to
        // make it easier for the tableview datasource to undestand the groupings
        var peopleGroups = [[Person]]()
        var distance = 2 // Skip over the user group, and the users's friends group
        while let group = vertexGroups[distance] {
            var people = group.map { $0.person }
            if distance == 2 {
                people = people.sorted(by: { lhs, rhs -> Bool in
                    return lhs.mutualCount ?? -1 > rhs.mutualCount ?? -1
                })
            }
            peopleGroups.append(people)
            distance += 1
        }
        
        let pymk = Array(peopleGroups.joined())
        return pymk
    }
    
    /**
    Generates the person graph from a list of persons to represent the friendships between those people
    */
    private func constructPeopleGraph(from people: [Person]) -> Graph {
        let graph = Graph()
        let user = people.first(where: { $0.isUser})
        let others = people.filter({ !$0.isUser })
        
        guard let user = user, !others.isEmpty else {
            return graph
        }
        
        var vertices = [Int: Vertex]()
        let userVertex = graph.addVertex(person: user)
        vertices[user.id] = userVertex
        
        for person in others {
            vertices[person.id] = graph.addVertex(person: person)
        }
        
        for person in people {
            let personvertex = vertices[person.id]
            for friend in person.friends {
                if let friendvertex = vertices[friend], let personvertex = personvertex {
                    graph.addEdge(personvertex, neighbor: friendvertex)
                }
            }
        }
        
        return bfs(graph: graph, source: userVertex)
    }
    
    /**
    Generates the shortest path graph, from a source vertex to every other vertex in the graph, using an existing graph
    */
    private func bfs(graph: Graph, source: Vertex) -> Graph {
        let shortestPathGraph = graph.duplicate()
        
        var queue = Queue()
        guard let sourceInShortestPathsGraph = shortestPathGraph.findVertex(with: source.person.id) else {
            return shortestPathGraph
        }
        
        queue.enqueue(element: sourceInShortestPathsGraph)
        sourceInShortestPathsGraph.distance = 0
        
        while let current = queue.dequeue() {
            for edge in current.neighbors {
                let neighborvertex = edge.neighbor
                if !neighborvertex.hasDistance {
                    queue.enqueue(element: neighborvertex)
                    neighborvertex.distance = current.distance! + 1
                }
                
                // At each level of the tree, determine the number of mutual connections
                // to the neightbor vertices. This number is only relevant for people who are
                // friends of friends, but it's just as performant to set this for everyone.
                if neighborvertex.distance! > current.distance! {
                    neighborvertex.increaseMutualFriendCount()
                }
            }
        }
        
        return shortestPathGraph
    }
}

