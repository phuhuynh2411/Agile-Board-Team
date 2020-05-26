//
//  APIIssue+GetTest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team
import XCTest

class APIIssueGetTest: XCTestCase {
    private var mock: Mock!
    private var apiIssue: APIIssue!
    private var timeout: TimeInterval = 1.0
    
    override func setUp() {
        self.mock = Mock()
        self.apiIssue = APIIssue()
        
        apiIssue.url = mock.testURL
        apiIssue.page = 1
        apiIssue.limit = 1
        apiIssue.search = mock.testSearch
        
        // Create a custom URLSession
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        let customPublisher = APISessionDataPublisher(session: session)
        apiIssue.publisher = customPublisher
    }
    
    override func tearDown() {
        mock = nil
        apiIssue = nil
        
        URLProtocolMock.testURLs = [:]
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
    }
    
    func testGetIssues() {
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: loadData("testingIssues", bundle: Bundle(for: Mock.self))]
        URLProtocolMock.response = mock.validResponse
        apiIssue.page = nil
        apiIssue.limit = nil
        apiIssue.search = nil
        
        // 1. Valid response
        let publisher = apiIssue.getIssues()
        let validResponse = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validResponse.expectations, timeout: timeout)
        validResponse.cancellable?.cancel()
        
        // 2. Invaid response due to invaid data
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.response = mock.invalidResponse
        let publisher2 = apiIssue.getIssues()
        let invalidResponse2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidResponse2.expectations, timeout: timeout)
        invalidResponse2.cancellable?.cancel()
        
        // 4. Invalid response due to network error
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.error = mock.networkError
        let publisher3 = apiIssue.getIssues()
        let invalidResponse3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidResponse3.expectations, timeout: timeout)
        invalidResponse3.cancellable?.cancel()
    }
    
    func testBuildGetIssueRequest() {
        apiIssue.url = mock.testURL
        apiIssue.page = 1
        apiIssue.limit = 1
        apiIssue.search = mock.testSearch
        
        let request = apiIssue.buildGetIssuesRequest()
        XCTAssertEqual(request.url?.absoluteString, "\(mock.testURL)?page=1&limit=1&search=\(mock.testSearch)")
    }
}
