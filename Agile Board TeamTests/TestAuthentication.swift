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
    
    override func setUp() {
        apiAuthentication = APIAuthentication()
    }
    
    override func tearDown() {
        
    }
    
    func evalValidResponseTest<T:Publisher>(publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        let cancellable = publisher?.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("--TEST ERROR--")
                print(error.localizedDescription)
                print("------")
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            print(response)
            expectationReceive.fulfill()
        })
        return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                cancellable: cancellable)
    }
    
    func evalInvalidResponseTest<T:Publisher>(publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "Invalid.finished")
        expectationFinished.isInverted = true
        let expectationReceive = expectation(description: "Invalid.receiveValue")
        expectationReceive.isInverted = true
        let expectationFailure = expectation(description: "Invalid.failure")
        
        let cancellable = publisher?.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("--TEST FULFILLED--")
                print(error.localizedDescription)
                print("------")
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            print(response)
            expectationReceive.fulfill()
        })
         return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                       cancellable: cancellable)
    }
}
