//
//  PeopleDataManager.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

final class PeopleDataManager {
    
    private let api: PeopleAPI
    
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
}

