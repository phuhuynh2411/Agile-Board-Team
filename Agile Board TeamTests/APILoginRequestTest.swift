//
//  APILoginRequestTest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team

class APILoginRequestTest: XCTestCase {
    
    var loginRequest: APILoginRequest!
    var baseURL: URL { URL(string: "https://task.huuhienqt.dev/")! }
    var session: MockURLSession!
    
    override func setUp() {
       session = MockURLSession()
    }

    override func tearDown() {
        loginRequest = nil
        session = nil
    }

    func testUsernameOrPasswordInvalid() {
        
        session.jsonFileName = "LoginError1"
        let response = HTTPURLResponse(url: baseURL, statusCode: 400, httpVersion: nil, headerFields: ["Content-type": "application/json"])

        session.urlResponse = response
        
        let username = "Fermentum Euismod"
        let password = "Tortor Cursus"
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login(username, password) { (data, response, error) in
            XCTAssertNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
        }
    }
    
    func testLoginSucceeded() {
        
        session.jsonFileName = "LoginSucceeded"
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-type": "application/json"])

        session.urlResponse = response
        
        let username = "Fermentum Euismod"
        let password = "Tortor Cursus"
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login(username, password) { (data, response, error) in
            XCTAssertNotNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
            
            XCTAssertNotNil(self.loginRequest.entry)
            XCTAssertNotNil(self.loginRequest.entry?.data)
            
            XCTAssertNotNil(AppState.shared.session)
            XCTAssertNotNil(AppState.shared.user)
        }
    }
    
    func testWrongMineType() {
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.urlResponse = response
        
        let username = "Fermentum Euismod"
        let password = "Tortor Cursus"
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login(username, password) { (data, response, error) in
            XCTAssertNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
        }
    }
    
    func testErrorOccurs() {
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.urlResponse = response
        session.error = NSError() // Any error
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login("", "") { (data, response, error) in
            XCTAssertNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
        }
    }
    
    func testServerError() {
        let response = HTTPURLResponse(url: baseURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        session.urlResponse = response
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login("", "") { (data, response, error) in
            XCTAssertNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
        }
    }
    
    func testEmptyData() {
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-type": "application/json"])

        session.urlResponse = response
        
        self.loginRequest = APILoginRequest(session: session)
        self.loginRequest.login("", "") { (data, response, error) in
            XCTAssertNil(try? self.loginRequest?.isLoginSucceeded(data, response, error))
        }
    }
    
}
