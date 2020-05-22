//
//  TokenManagerTest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/22/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team

class TokenManagerTest: XCTestCase {
    private var userDefault: UserDefaults!
    private var tokenManager: TokenManager!
    private var mock = Mock()
    
    override func setUp() {
        userDefault = UserDefaults(suiteName: #file)
        userDefault.removePersistentDomain(forName: #file)
        
        tokenManager = TokenManager(userDefault: self.userDefault)
    }
    
    override func tearDown() {
        self.userDefault = nil
        self.tokenManager = nil
    }
    
    func testToken() {
        tokenManager.setToken(mock.token)
        let token = tokenManager.getToken()
        
        XCTAssertEqual(token, mock.token)
    }
}
