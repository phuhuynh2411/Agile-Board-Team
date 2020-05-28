//
//  APIIssue+Delete.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team
import XCTest
import Combine

class APIIssueDeleteTest: XCTestCase {
    private var mock: Mock!
    private var apiIssue: APIIssue!
    private var timeout: TimeInterval = 1.0
    private var stream: AnyCancellable!
    
    override func setUp() {
        self.mock = Mock()
        self.apiIssue = APIIssue()
        
        apiIssue.url = mock.testURL
        
        // Create a custom URLSession
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        let customPublisher = APISessionDataPublisher(session: session)
        apiIssue.publisher = customPublisher
    }
     
    override func tearDown() {
        self.mock = nil
        self.apiIssue = nil
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [: ]
    }
    
    func testBuildDeleteIssueRequest() {
        
        let request = apiIssue.buildDeleteIssueRequest(mock.validIssue)
        // 1. make sure the http method is DELETE
        XCTAssertEqual(request.httpMethod!, "DELETE")
        // 2. make sure the url is correct
        XCTAssertEqual(request.url!.absoluteString, "\(mock.testURL)/\(mock.validIssue.id)")
        // 3. include the Authorization hearder
        XCTAssertNotNil(request.allHTTPHeaderFields?["Authorization"])
    }
    
    func testDeleteIssue() {
        URLProtocolMock.testURLs = [mock.testURL.appendingPathComponent(mock.validIssue.id): Data(Fixture.deleteIssueResponseJSON.utf8)]
        URLProtocolMock.response = mock.validResponse
        // 1. Valid response
        let publisher = apiIssue.delete(mock.validIssue)
        let validResponse = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validResponse.expectations, timeout: timeout)
        validResponse.cancellable?.cancel()
        // 1.1 returns an issue if it has been deleted
        let expectation1 = expectation(description: "returns an issue")
        self.stream = publisher.sink(receiveCompletion: { (complete) in
            switch complete {
            case .failure( let error):
                print(error)
                XCTFail()
            case .finished: break
            }
        }, receiveValue: { (issue) in
            XCTAssertEqual(issue, self.mock.validIssue)
            expectation1.fulfill()
        })
        wait(for: [expectation1], timeout: timeout)
        
        
        // 2. Invaid response due to invaid data
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.response = mock.invalidResponse
        let publisher2 = apiIssue.delete(mock.validIssue)
        let invalidResponse2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidResponse2.expectations, timeout: timeout)
        invalidResponse2.cancellable?.cancel()
        
        // 3. Invalid response due to network error
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.error = mock.networkError
        let publisher3 = apiIssue.delete(mock.validIssue)
        let invalidResponse3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidResponse3.expectations, timeout: timeout)
        invalidResponse3.cancellable?.cancel()
    }
}
