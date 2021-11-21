//
//  PYMKTests.swift
//  PYMKTests
//
//  Created by Joe on 11/20/21.
//

import XCTest
@testable import PYMK

class MockAPI: PeopleAPI {

    func getPeople(completion: @escaping (Result<[Person], APIError>) -> Void) {
        var people = [Person]()
        people.append(Person(id: 1, name: "Facebook Candidate", friends: [2, 5, 6], mutualCount: nil))
        people.append(Person(id: 2, name: "Friend-1", friends: [1, 3, 4], mutualCount: nil))
        people.append(Person(id: 3, name: "Friend-Of-Friend-1-1", friends: [2, 4], mutualCount: nil))
        people.append(Person(id: 4, name: "Friend-Of-Friend-1-2", friends: [3, 2, 8], mutualCount: nil))
        people.append(Person(id: 5, name: "Friend-2", friends: [1, 6, 7], mutualCount: nil))
        people.append(Person(id: 6, name: "Friend-3", friends: [1, 5, 7], mutualCount: nil))
        people.append(Person(id: 7, name: "Friend-Of-Friend-2-and-Friend-3", friends: [5, 6], mutualCount: nil))
        people.append(Person(id: 8, name: "Friend-Of-Friend-Of-Friend-1-2", friends: [4], mutualCount: nil))
        completion(.success(people))
    }
}

class PYMKTests: XCTestCase {
    
    private var people = [Person]()
    
    // Swift
    override func setUp() {
        super.setUp()

        let exp = expectation(description: "\(#function)\(#line)")
        
        let mockAPI = MockAPI()
        let dataManager = PeopleDataManager(api: mockAPI)
        
        dataManager.getPeopleYouMayKnow { result in
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
    
    func testPeopleYouMayKnowDoesNotIncludePeopleYouDoKnow() {
        XCTAssertFalse(people.contains(where: { $0.name == "Facebook Candidate"}))
        XCTAssertFalse(people.contains(where: { $0.name == "Friend-1"}))
        XCTAssertFalse(people.contains(where: { $0.name == "Friend-2"}))
        XCTAssertFalse(people.contains(where: { $0.name == "Friend-3"}))
    }
    
    func testPeopleYouMayKnowIncludesPeopleYouMayKnow() {
        XCTAssertTrue(people.contains(where: { $0.name == "Friend-Of-Friend-1-1"}))
        XCTAssertTrue(people.contains(where: { $0.name == "Friend-Of-Friend-1-2"}))
        XCTAssertTrue(people.contains(where: { $0.name == "Friend-Of-Friend-2-and-Friend-3"}))
        XCTAssertTrue(people.contains(where: { $0.name == "Friend-Of-Friend-Of-Friend-1-2"}))
    }
    
    func testPeopleYouMayKnowHaveCorrectSocialDistance() {
        if let candidate = people.first(where: { $0.name == "Facebook Candidate"}) {
            XCTAssertTrue(candidate.distance == 0)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-1"}) {
            XCTAssertTrue(candidate.distance == 1)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-2"}) {
            XCTAssertTrue(candidate.distance == 1)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-3"}) {
            XCTAssertTrue(candidate.distance == 1)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-Of-Friend-1-1"}) {
            XCTAssertTrue(candidate.distance == 2)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-Of-Friend-1-2"}) {
            XCTAssertTrue(candidate.distance == 2)
        }
        
        if let candidate = people.first(where: { $0.name == "Friend-Of-Friend-2-and-Friend-3"}) {
            XCTAssertTrue(candidate.distance == 2)
        }
                                                
        if let candidate = people.first(where: { $0.name == "Friend-Of-Friend-Of-Friend-1-2"}) {
            XCTAssertTrue(candidate.distance == 3)
        }
    }
    
    func testFriendsOfFriendsAreOrderedByMutualFriendCount() {
        XCTAssertTrue(people[0].name == "Friend-Of-Friend-2-and-Friend-3")
        XCTAssertTrue(people[1].name == "Friend-Of-Friend-1-1")
        XCTAssertTrue(people[2].name == "Friend-Of-Friend-1-2")
    }
}
