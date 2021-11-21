//
//  JSONAPI.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

final class JSONAPI: PeopleAPI {
    
    private let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func getPeople(completion: @escaping (Result<[Person], APIError>) -> Void) {
        parseResponse(completion: completion)
    }
    
    // MARK: Private
    
    private func parseResponse(completion: @escaping (Result<[Person], APIError>) -> Void) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let people = try decoder.decode([Person].self, from: data)
                completion(.success(people))
            } catch let decodingError as DecodingError {
                completion(.failure(.decodingError(decodingError)))
            }
            catch {
                completion(.failure(.unknownError(error)))
            }
        }
    }
}

