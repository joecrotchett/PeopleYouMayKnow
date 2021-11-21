//
//  Person.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

struct Person: Decodable {
    
    static let userName = "Facebook Candidate"
    
    let id: Int
    let name: String
    let friends: [Int]
    var mutualCount: Int?
    var isFriendOfUser: Bool?
    
    var isUser: Bool {
        name == Person.userName
    }
}
