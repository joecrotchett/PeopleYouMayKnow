//
//  PYMKTests.swift
//  PYMKTests
//
//  Created by Joe on 11/20/21.
//

import XCTest
@testable import PYMK

class PYMKTests: XCTestCase {
    
    private var people = [Person]()
    
    // Swift
    override func setUp() {
        super.setUp()

        let exp = expectation(description: "\(#function)\(#line)")
        
        let api = JSONAPI(filename: "mock")
        let dataManager = PeopleDataManager(api: api)
        
        dataManager.getPeople { result in
            switch result {
            case .success(let people):
                self.people = people
                
            case .failure(let error):
                XCTFail("Something ain't right: \(error.localizedDescription)")
            }
            
            exp.fulfill()
        }

        // Wait for the async request to complete
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJSONParsing() throws {
        XCTAssertEqual(people.count, 8)
    }
}
