//
//  Mock.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team

class Mock {
    let invalidResponse = URLResponse(url: URL(string: "http://localhost:8080")!,
                                      mimeType: nil,
                                      expectedContentLength: 0,
                                      textEncodingName: nil)
    
    let validResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)
    
    let validResponseWithFullParas = HTTPURLResponse(url: URL(string: "http://localhost:8080?page=1&limit=1&keyword=keyword")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)
    
    let invalidResponse300 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 300,
                                           httpVersion: nil,
                                           headerFields: nil)
    let invalidResponse401 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 401,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    let invalidResponse400 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 400,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    let networkError = NSError(domain: "NSURLErrorDomain",
                               code: -1004, //kCFURLErrorCannotConnectToHost
                               userInfo: nil)
    
    let invalidEmail = "invalid@gmail.com"
    let invalidPassword = "invalidPassword"
    let validEmail = "valid@gmail.com"
    let validPassword = "validPassword"
    let testErrorDescription = "testError"
    
    let token = "testingToken"
    
    var testURL = URL(string: "http://localhost:8080")!
    let testURLFullParas = URL(string: "http://localhost:8080?page=1&limit=1&search=keyword")!
    var testRequest: URLRequest {
        URLRequest(url: testURL)
    }
    
    let testSearch = "testSearch"
    
    let updateIssue = UpdateIssueRequest(projectId: "1", parentId: "1", categoryId: "1", typeId: "1", priorityId: "1", statusId: "1", assigneeId: "1", name: "name", description: "des", startDate: Date(timeIntervalSince1970: 1), endDate: Date(timeIntervalSince1970: 1))
}
