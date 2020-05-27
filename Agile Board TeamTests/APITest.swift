//
//  APITest.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/21/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board_Team
import Combine

class APITest: XCTestCase {
    private var api: API<Fixture.DummyCodable>!
    private var mock: Mock!
    private var timeout: TimeInterval = 1.0
    
    private var customPublisher: APISessionDataPublisher!
    
    override func setUp() {
        api = API<Fixture.DummyCodable>()
        mock = Mock()
        
        // Create a custom URL session
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        // Change API's publisher to the custom publishers
        self.customPublisher = APISessionDataPublisher(session: session)
        api.publisher = customPublisher
    }
    
    override func tearDown() {
        self.api = nil
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [:]
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
    
    func testValidate() {
        // 1. The response is not http response
        let dumpmyData = Data()
        XCTAssertThrowsError(try api.validate(dumpmyData, URLResponse()), "Throw APIError.inValidResponse") { (error) in
            XCTAssertEqual(error as! APIError, APIError.invalidRespond)
        }
        
        // 2. Invalid response 401
        XCTAssertThrowsError(try api.validate(dumpmyData, mock.invalidResponse401!), "Invalid response 401") { (error) in
            XCTAssertEqual(error as! APIError, APIError.statusCode(401))
        }
        
        // 3. Valid response, and returns data
        XCTAssertNoThrow(try api.validate(dumpmyData, mock.validResponse!), "No throw, and returns data")
    }
    
    func testSend() {
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        
        // 1. Valid response
        URLProtocolMock.response = mock.validResponse
        let publisher = api.send(request: mock.testRequest)
        
        let validTest = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validTest.expectations, timeout: self.timeout)
        validTest.cancellable?.cancel()
        
        // 2. Invalid response due to invalid http response
        URLProtocolMock.response = mock.invalidResponse
        let publisher2 = api.send(request: mock.testRequest)
        let invalidTest = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidTest.expectations, timeout: self.timeout)
        invalidTest.cancellable?.cancel()
        
        // 3. Invalid respponse due to invalid data
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.emptyJSON.utf8)]
        URLProtocolMock.response = mock.validResponse
        let publisher3 = api.send(request: mock.testRequest)
        let invalidTest2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidTest2.expectations, timeout: self.timeout)
        invalidTest2.cancellable?.cancel()
        
        // 4. Invalid response due to network error
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.error = mock.networkError
        let publisher4 = api.send(request: mock.testRequest)
        let invalidTest3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher4)
        wait(for: invalidTest3.expectations, timeout: self.timeout)
        invalidTest3.cancellable?.cancel()
        
    }
    
    func testAddQueryItem() {
        // 1. page = 1, limit = 1, keyword = keyword
        let url = api.addQueryItems(page: 1, limit: 1, search: "keyword", to: mock.testURL)
        XCTAssertEqual(url.absoluteString, "\(mock.testURL)?page=1&limit=1&search=keyword" )
        
        // 2. empty query items
        let url1 = api.addQueryItems(to: mock.testURL)
        XCTAssertEqual(url1.absoluteString, "\(mock.testURL)" )
        
        // 3. only page = 1
        let url2 = api.addQueryItems(page: 1, to: url)
        XCTAssertEqual(url2.absoluteString, "\(mock.testURL)?page=1" )
        
        // 4. only limit = 1
        let url3 = api.addQueryItems(limit: 1, to: url)
        XCTAssertEqual(url3.absoluteString, "\(mock.testURL)?limit=1" )
        
        // 5. only keyword = keyword
        let url4 = api.addQueryItems(search: "keyword", to: url)
        XCTAssertEqual(url4.absoluteString, "\(mock.testURL)?search=keyword" )
    }
    
    func testGetData() {
        
        URLProtocolMock.testURLs = [mock.testURLFullParas: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.response = mock.validResponseWithFullParas
        
        let publisher = api.getData(from: mock.testURL, page: 1, limit: 1, search: "keyword")
        let validResponse = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validResponse.expectations, timeout: timeout)
        validResponse.cancellable?.cancel()
    }
    
    func testGenericSend() {
        // Setup fixture
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        
        // 1. Valid response
        URLProtocolMock.response = mock.validResponse
        let publisher: AnyPublisher<Fixture.DummyCodable, Error> = api.send(request: mock.testRequest)
        
        let validTest = PublisherHelper.shared.evalValidResponseTest(publisher: publisher)
        wait(for: validTest.expectations, timeout: self.timeout)
        validTest.cancellable?.cancel()
        
        // 2. Invalid response due to invalid http response
        URLProtocolMock.response = mock.invalidResponse
        let publisher2: AnyPublisher<Fixture.DummyCodable, Error> = api.send(request: mock.testRequest)
        let invalidTest = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher2)
        wait(for: invalidTest.expectations, timeout: self.timeout)
        invalidTest.cancellable?.cancel()
        
        // 3. Invalid respponse due to invalid data
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.emptyJSON.utf8)]
        URLProtocolMock.response = mock.validResponse
        let publisher3: AnyPublisher<Fixture.DummyCodable, Error> = api.send(request: mock.testRequest)
        let invalidTest2 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher3)
        wait(for: invalidTest2.expectations, timeout: self.timeout)
        invalidTest2.cancellable?.cancel()
        
        // 4. Invalid response due to network error
        URLProtocolMock.testURLs = [mock.testURL: Data(Fixture.dummyResponse.utf8)]
        URLProtocolMock.error = mock.networkError
        let publisher4: AnyPublisher<Fixture.DummyCodable, Error> = api.send(request: mock.testRequest)
        let invalidTest3 = PublisherHelper.shared.evalInvalidResponseTest(publisher: publisher4)
        wait(for: invalidTest3.expectations, timeout: self.timeout)
        invalidTest3.cancellable?.cancel()
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
