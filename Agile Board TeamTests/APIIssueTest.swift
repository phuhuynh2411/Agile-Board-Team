//
//  APIIssueTest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import XCTest
@testable import Agile_Board_Team

class APIIssueTest: XCTestCase {
    private var mock: Mock!
    private var apiIssue: APIIssue!
    
    override func setUp() {
        self.mock = Mock()
        self.apiIssue = APIIssue()
    }
    
    override func tearDown() {
        mock = nil
        apiIssue = nil
    }
    
    func testValiate() {
        XCTAssertThrowsError(try apiIssue.validate(entry: Fixture.issueEntryResponse401), "") { (error) in
            XCTAssertEqual(error as! APIIssue.IssueAPIError, APIIssue.IssueAPIError.failure(""))
        }
        XCTAssertNoThrow(try apiIssue.validate(entry: Fixture.issueEntryResponse200))
    }
    
    func testErrorDescription() {
        let error = APIIssue.IssueAPIError.failure(mock.testErrorDescription)
        XCTAssertEqual(error.localizedDescription, mock.testErrorDescription)
    }
}
