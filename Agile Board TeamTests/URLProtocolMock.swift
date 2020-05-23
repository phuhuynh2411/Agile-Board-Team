//
//  URLProtocolMock.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

// Reference link: https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way

/*
 How to create a test
 // this is the URL we expect to call
 let url = URL(string: "https://www.apple.com/newsroom/rss-feed.rss")

 // attach that to some fixed data in our protocol handler
 URLProtocolMock.testURLs = [url: Data("Hacking with Swift!".utf8)]

 // now set up a configuration to use our mock
 let config = URLSessionConfiguration.ephemeral
 config.protocolClasses = [URLProtocolMock.self]

 // and create the URLSession from that
 let session = URLSession(configuration: config)
 */

import Foundation

@objc class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()
    static var response: URLResponse?
    static var error: Error?
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // …and we return our response if defined…
        if let response = URLProtocolMock.response {
            self.client?.urlProtocol(self,
                                     didReceive: response,
                                     cacheStoragePolicy: .notAllowed)
        }
        
        // …and we return our error if defined…
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() {

    }
}
