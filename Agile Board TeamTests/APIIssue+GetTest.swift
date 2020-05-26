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
        mock = nil
        apiIssue = nil
        
        URLProtocolMock.testURLs = [:]
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
    }
    
    func testGetIssues() {
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: loadData("issues")]
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
