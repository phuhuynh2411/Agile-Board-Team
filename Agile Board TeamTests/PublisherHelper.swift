//
//  Publisher+Extension.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine
import XCTest

class PublisherHelper: XCTestCase {
    
    static var shared = PublisherHelper()
    
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
