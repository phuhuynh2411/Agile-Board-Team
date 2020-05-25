//
//  TestAuthentication.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 4/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team
import Combine

//class TestAuthentication: XCTestCase {
//    var sut: Authentication!
//     var loginNotification: AnyCancellable?
//
//    override func setUpWithError() throws {
//        sut = Authentication()
//
//        // Test login notification
//        loginNotification = NotificationCenter.default.publisher(for: .didLoginSucceed)
//            .receive(on: RunLoop.main)
//            .map {$0.userInfo?[UserDefaultKey.accessToken] as! String
//        }
//        .sink(receiveCompletion: { (completion) in
//            print(completion)
//        }, receiveValue: { (value) in
//            print(value)
//            XCTAssertNotNil(value)
//        })
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//    }
//
//    func testEmptyUserNameAndPassword() {
//        let expectation = XCTestExpectation(description: "Wait for response")
//        let cancelableLoginStream = sut.login("", "")
//            .sink(receiveCompletion: { (completion) in
//                print(completion)
//                guard case .failure = completion else {
//                    XCTFail("Wrong error")
//                    return
//                }
//                expectation.fulfill()
//            }) { print($0) }
//
//        wait(for: [expectation], timeout: 10.0)
//        cancelableLoginStream.cancel()
//    }
//
//    func testEmptyUserName() {
//        let expectation = XCTestExpectation(description: "Wait for response")
//        let cancelableLoginStream = sut.login("", "asdfjdsf")
//            .sink(receiveCompletion: { (completion) in
//                print(completion)
//                guard case .failure = completion else {
//                    XCTFail("Wrong error")
//                    return
//                }
//                expectation.fulfill()
//            }) { print($0) }
//
//        wait(for: [expectation], timeout: 10.0)
//        cancelableLoginStream.cancel()
//    }
//
//    func testEmptyPassword() {
//        let expectation = XCTestExpectation(description: "Wait for response")
//        let cancelableLoginStream = sut.login("admin@gmail.com", "")
//            .sink(receiveCompletion: { (completion) in
//                print(completion)
//                guard case .failure = completion else {
//                    XCTFail("Wrong error")
//                    return
//                }
//                expectation.fulfill()
//            }) { print($0) }
//
//        wait(for: [expectation], timeout: 10.0)
//        cancelableLoginStream.cancel()
//    }
//
//    func testInvalidCredentials() {
//        let expectation = XCTestExpectation(description: "Wait for response")
//        let cancelableLoginStream = sut.login("admin@gmail.com", "invalid password")
//            .sink(receiveCompletion: { (completion) in
//                print(completion)
//                guard case .failure = completion else {
//                    XCTFail("Wrong error")
//                    return
//                }
//                expectation.fulfill()
//            }) { print($0) }
//
//        wait(for: [expectation], timeout: 10.0)
//        cancelableLoginStream.cancel()
//    }
//
//    func testValidCredentials() {
//        let expectation = XCTestExpectation(description: "Wait for response")
//        let cancelableLoginStream = sut.login("admin@gmail.com", "123qwe!@#")
//            .sink(receiveCompletion: { (completion) in
//                print(completion)
//                guard case .finished = completion else {
//                    XCTFail("The login must be successful.")
//                    return
//                }
//                expectation.fulfill()
//            }) {
//                print($0.accessToken)
//                XCTAssertNotNil($0.accessToken)
//                XCTAssertEqual($0.accessToken, UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? "")
//        }
//
//        wait(for: [expectation], timeout: 30.0)
//        cancelableLoginStream.cancel()
//    }
//
//}

class TestAuthentication: XCTestCase {
    private var apiAuthentication: APIAuthentication!
    private var mock: Mock!
    private var timeout: TimeInterval = 1.0
    private var loginStream: AnyCancellable?
    
    override func setUp() {
        mock = Mock()
        apiAuthentication = APIAuthentication(loginURL: mock.testURL)
        
        // Configue a custom URLSession
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        // create a custom session
        let session = URLSession(configuration: config)
        let customPublisher = APISessionDataPublisher(session: session)
        apiAuthentication.publisher = customPublisher
    }
    
    override func tearDown() {
        mock = nil
        apiAuthentication = nil
    }
    
    func testLogin() {
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.failureAuthentication400.utf8)]
        URLProtocolMock.response = mock.invalidResponse400
        
        // 1. Empty user name and empty password
        let publisher = apiAuthentication.login("", "")
        let invalidResponse = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher)
        wait(for: invalidResponse.expectations, timeout: timeout)
        invalidResponse.cancellable?.cancel()
        
        // 2. Empty user name, not empty password
        let publisher2 = apiAuthentication.login("", "notEmptyPassword")
        let invalidResponse2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidResponse2.expectations, timeout: timeout)
        invalidResponse2.cancellable?.cancel()
        
        // 3. Not empty user name, empty password
        let publisher3 = apiAuthentication.login("invalidUserName", "")
        let invalidResponse3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidResponse3.expectations, timeout: timeout)
        invalidResponse3.cancellable?.cancel()
        
        // 4. Invalid user name and password
        let publisher4 = apiAuthentication.login("invalidUsername", "invalidPassword")
        let invalidResponse4 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher4)
        wait(for: invalidResponse4.expectations, timeout: timeout)
        invalidResponse4.cancellable?.cancel()
    }
    
    func testLogin2() {
        // Make sure the didLoginSucceed notification is sent
        let loginExpectation = expectation(description: "Login stream")
        loginStream = NotificationCenter.default.publisher(for: .didLoginSucceed)
            .receive(on: RunLoop.main)
            .compactMap {$0.userInfo?[UserDefaultKey.accessToken] as? String
        }
        .sink(receiveValue: { (value) in
            print("View router received notification value: \(value)")
            XCTAssertEqual(value, self.mock.token)
            loginExpectation.fulfill()
        })
        
        // 5. Valid user name and valid password
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.successAuthentication.utf8)]
        URLProtocolMock.response = mock.validResponse
        // Change userdefault domain
        TokenManager.shared = TokenManager(userDefault: UserDefaults(suiteName: #file)!)
        TokenManager.shared.userDefault.removePersistentDomain(forName: #file)
        
        let publisher5 = apiAuthentication.login(mock.validEmail, mock.validPassword)
        let validResponse = PublisherHelper.shared.evalValidResponseTest(publisher: publisher5)
        wait(for: validResponse.expectations, timeout: timeout)
        validResponse.cancellable?.cancel()
        // Make sure the token is set
        XCTAssertNotNil(TokenManager.shared.getToken())
        if let token = TokenManager.shared.getToken() {
            XCTAssertEqual("testingToken", token)
        }
        
        wait(for: [loginExpectation], timeout: 10)
    }
    
    func testValidate() {
        // 1. Invalid credentials
        XCTAssertThrowsError(try apiAuthentication.validate(entry: Fixture.invalidCredential401), "") { (error) in
            XCTAssertEqual(error as! APIAuthentication.AuthenticationError, APIAuthentication.AuthenticationError.invalidCredential(""))
        }
        
        // 2. Empty access token
        XCTAssertThrowsError(try apiAuthentication.validate(entry: Fixture.emptyAccessToken200), "") { (error) in
            print(error.localizedDescription)
            XCTAssertEqual(error as! APIAuthentication.AuthenticationError, APIAuthentication.AuthenticationError.emptyToken)
        }
    }
    
}
