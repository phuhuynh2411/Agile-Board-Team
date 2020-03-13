//
//  LoginModelViewTest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team

class LoginModelViewTest: XCTestCase {
    
    var loginRequest: APILoginRequest!
    var baseURL: URL { URL(string: "https://task.huuhienqt.dev/")! }
    var session: MockURLSession!
    var loginModelView: LoginModelView!
    
    override func setUp() {
        session = MockURLSession()
        loginModelView = LoginModelView()
        loginModelView.session = session
    }
    
    override func tearDown() {
        loginRequest = nil
        session = nil
        loginModelView = nil
    }
    
    func testEmailEmpty() {
        loginModelView.login()
        loginModelView.password = "abck"
        loginModelView.username = ""
        XCTAssertTrue(loginModelView.loginDidFail)
    }
    
    func testPasswordEmpty() {
        loginModelView.login()
        loginModelView.password = ""
        loginModelView.username = "plato"
        XCTAssertTrue(loginModelView.loginDidFail)
    }
    
    func testUsernameOrPasswordInvalid() {
        loginModelView.login()
        loginModelView.password = "ddd"
        loginModelView.username = "plato"
        XCTAssertTrue(loginModelView.loginDidFail)
    }
    
    func testLoginSucceeded() {
        session.jsonFileName = "LoginSucceeded"
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-type": "application/json"])
        session.urlResponse = response
        
        loginModelView.password = "plato"
        loginModelView.username = "plato"
        loginModelView.login()
    
        XCTAssertTrue(loginModelView.loginDidSucceed)
    }

}