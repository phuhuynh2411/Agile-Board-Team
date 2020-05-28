//
//  APIIssue+Add.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team
import XCTest
import Combine

class APIIssueAddTest: XCTestCase {
    private var mock: Mock!
    private var apiIssue: APIIssue!
    private var timeout: TimeInterval = 1.0
    
    override func setUp() {
        self.mock = Mock()
        self.apiIssue = APIIssue()
        
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
    }
    
    func testBuildAddIssueRequest() {
        // 1. Make sure the request method is POST
        let request = apiIssue.buildAddIssueRequest(mock.validIssue)
        XCTAssertEqual(request.httpMethod!, "POST")
        
        // 2. The request body not empty
        let data = try! apiIssue.defaultJSONEncoder.encode(mock.validIssue)
        XCTAssertEqual(request.httpBody, data)
    }
    
    func testAdd() {
        URLProtocolMock.testURLs = [mock.testURL: try! apiIssue.defaultJSONEncoder.encode(mock.validAddIssueRepsonse)]
        URLProtocolMock.response = mock.validResponse
        apiIssue.url = mock.testURL
        // 1. Valid response
        let publisher = apiIssue.add(mock.validIssue)
        let validResponse = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validResponse.expectations, timeout: timeout)
        validResponse.cancellable?.cancel()
        
        // 2. Invaid response due to invaid data
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.response = mock.invalidResponse
        let publisher2 = apiIssue.add(mock.validIssue)
        let invalidResponse2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidResponse2.expectations, timeout: timeout)
        invalidResponse2.cancellable?.cancel()
        
        // 3. Invalid response due to network error
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.error = mock.networkError
        let publisher3 = apiIssue.add(mock.validIssue)
        let invalidResponse3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidResponse3.expectations, timeout: timeout)
        invalidResponse3.cancellable?.cancel()
    }
}
