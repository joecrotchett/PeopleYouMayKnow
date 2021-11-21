//
//  PeopleAPI.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import Foundation

// MARK: PeopleAPI

protocol PeopleAPI {
    func getPeople(completion: @escaping (Result<[Person], APIError>) -> Void)
}

// MARK: APIError

// Only `decodingError` is used in the current implementation,
// but the rest are here to support network-based implemenations
enum APIError : Error {
    case networkingError(Error)
    case serverError
    case requestError(Int, String)
    case invalidResponse
    case decodingError(DecodingError)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .networkingError(let error): return "Error sending request: \(error.localizedDescription)"
        case .serverError: return "HTTP 500 Server Error"
        case .requestError(let status, let body): return "HTTP \(status)\n\(body)"
        case .invalidResponse: return "Invalid Response"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
