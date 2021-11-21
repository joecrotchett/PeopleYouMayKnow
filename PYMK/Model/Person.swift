//
//  Person.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

struct Person: Codable {
    let id: Int
    let name: String
    let friends: [Int]
}
