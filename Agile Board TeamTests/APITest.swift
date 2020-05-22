//
//  APITest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/21/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team

class APITest: XCTestCase {
    private var api: API<Fixture.DummyCodable>!
    private var mock: Mock!
    
    override func setUp() {
        api = API<Fixture.DummyCodable>()
        mock = Mock()
    }
    
    override func tearDown() {
        self.api = nil
    }
    
    func testDefaultHeader() {
        XCTAssertEqual(api.defaultHeaders["Content-Type"], "application/json")
        XCTAssertEqual(api.defaultHeaders["cache-control"], "no-cache")
    }
    
    func testDefaultJSONDecoder() {
        XCTAssertEqual(api.defaultJSONDecoder.dateDecodingStrategy, .iso8601)
        XCTAssertEqual(api.defaultJSONDecoder.keyDecodingStrategy, .convertFromSnakeCase)
    }
    
    func testPostRequest() {
        //1. without authentication
        let request = api.postRequest(url: mock.testURL)
        
        // Post method
        XCTAssertEqual(request.httpMethod!, "POST")
        
        //2. with authentication header
        let userDefault = UserDefaults(suiteName: #file)!
        userDefault.removePersistentDomain(forName: #file)
        
        TokenManager.shared = TokenManager(userDefault: userDefault)
        TokenManager.shared.setToken(mock.token)
        let requestWithAuthentication = api.postRequest(url: mock.testURL, authen: true)
        // Post method
        XCTAssertEqual(requestWithAuthentication.httpMethod!, "POST")
        
        // Anthentication header
        XCTAssertEqual("Bearer \(mock.token)", requestWithAuthentication.allHTTPHeaderFields!["Authorization"])
    }
    
    func testGetRequest() {
        //1. without authentication
        let request = api.getRequest(url: mock.testURL)
        
        // Post method
        XCTAssertEqual(request.httpMethod!, "GET")
        
        //2. with authentication header
        let userDefault = UserDefaults(suiteName: #file)!
        userDefault.removePersistentDomain(forName: #file)
        
        TokenManager.shared = TokenManager(userDefault: userDefault)
        TokenManager.shared.setToken(mock.token)
        let requestWithAuthentication = api.getRequest(url: mock.testURL, authen: true)
        // Post method
        XCTAssertEqual(requestWithAuthentication.httpMethod!, "GET")
        
        // Anthentication header
        XCTAssertEqual("Bearer \(mock.token)", requestWithAuthentication.allHTTPHeaderFields!["Authorization"])
    }
    
    func testPutRequest() {
        //1. without authentication
        let request = api.putRequest(url: mock.testURL)
        
        // Post method
        XCTAssertEqual(request.httpMethod!, "PUT")
        
        //2. with authentication header
        let userDefault = UserDefaults(suiteName: #file)!
        userDefault.removePersistentDomain(forName: #file)
        
        TokenManager.shared = TokenManager(userDefault: userDefault)
        TokenManager.shared.setToken(mock.token)
        let requestWithAuthentication = api.putRequest(url: mock.testURL, authen: true)
        // Post method
        XCTAssertEqual(requestWithAuthentication.httpMethod!, "PUT")
        
        // Anthentication header
        XCTAssertEqual("Bearer \(mock.token)", requestWithAuthentication.allHTTPHeaderFields!["Authorization"])
    }
    
    func testNilToken() {
        //1.  If the token is nil, make sure there is no Authorization header in the request
        
        let userDefault = UserDefaults(suiteName: #file)!
        userDefault.removePersistentDomain(forName: #file)
        TokenManager.shared = TokenManager(userDefault: userDefault)
        
        let request = api.putRequest(url: mock.testURL, authen: true)
        XCTAssertNil(request.allHTTPHeaderFields!["Authorization"])
        
        //2. If the token is not nil, make sure there is an Authorization in the header of the request
        TokenManager.shared.setToken(mock.token)
        let request1 = api.putRequest(url: mock.testURL, authen: true)
        XCTAssertNotNil(request1.allHTTPHeaderFields!["Authorization"])
        XCTAssertEqual(request1.allHTTPHeaderFields!["Authorization"], "Bearer \(mock.token)")
    }
}
