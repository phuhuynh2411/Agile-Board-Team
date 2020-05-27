//
//  API.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class API <ResponseData: Codable> {
    /// Default header for each request
    var defaultHeaders = [
        "Content-Type": "application/json",
        "cache-control": "no-cache",
    ]
    
    /// Default JSONDecoder
    var defaultJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    /// Default JSONEncoder for the API
    var defaultJSONEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    // A request timeout
    var timeoutInterval: TimeInterval = 10.0
    
    // A publisher that does the request
    var publisher: APISessionDataPublisher = APISessionDataPublisher()
        
    internal func postRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "POST"
        return request
    }
    
    internal func getRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "GET"
        return request
    }
    
    internal func putRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "PUT"
        return request
    }
    
    private func request(url: URL, authen: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.defaultHeaders
        request.timeoutInterval = timeoutInterval
        if authen {
            guard let token = TokenManager.shared.getToken() else { return request }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func printJSON(data: Data?) {
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("RESPONSE DATA: \(dataString)")
        }
    }
    
    internal func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        self.printJSON(data: data)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidRespond }
        
        guard httpResponse.statusCode != 401 else {
            NotificationCenter.default.post(name: .statusCode401, object: self)
            throw APIError.statusCode(httpResponse.statusCode)
        }
        return data
    }
    
    internal func send(request: URLRequest) -> AnyPublisher<ResponseData, Error> {
        return publisher
            .dataTaskPublisher(for: request)
            .tryMap { try self.validate($0.data, $0.response) }
            .decode(type: ResponseData.self, decoder: self.defaultJSONDecoder )
            .eraseToAnyPublisher()
    }
    
    internal func send<T: Codable> (request: URLRequest) -> AnyPublisher<T, Error> {
        return publisher
            .dataTaskPublisher(for: request)
            .tryMap { try self.validate($0.data, $0.response) }
            .decode(type: T.self, decoder: self.defaultJSONDecoder )
            .eraseToAnyPublisher()
    }
    
    internal func getData(from url: URL, page: Int? = nil, limit: Int? = nil, search: String? = nil) -> AnyPublisher<ResponseData, Error> {
        // Create a URL with parameters
        let url = self.addQueryItems(page: page, limit: limit, search: search, to: url)
        // Create a get request from a url, embed the access token
        let request = self.getRequest(url: url, authen: true)
        return send(request: request)
    }
    
    /**
     Add query items with page number, a number of items and keyword to the URL
     - parameter page: the page number
     - parameter limit: a number of items
     - parameter keyword: a search criteria
     - parameter url: the URL that will be included the query items
    
     - Returns: A new URL included the query items
     */
    internal func addQueryItems(page: Int? = nil, limit: Int? = nil, search: String? = nil, to url: URL) -> URL {
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = []
        if let page = page {
            urlComponent.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let limit = limit {
            urlComponent.queryItems?.append(URLQueryItem(name: "limit", value: "\(limit)") )
        }
        if let search = search {
            urlComponent.queryItems?.append(URLQueryItem(name: "search", value: "\(search)") )
        }
        
        // Remove an extra question mark at the end of the URL if the query item is empty.
        if urlComponent.queryItems?.count == 0 {
            urlComponent.queryItems = nil
        }
        
        return urlComponent.url!
    }
}
