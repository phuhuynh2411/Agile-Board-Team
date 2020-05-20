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
    
    var timeoutInterval: TimeInterval = 10.0
    var publisher: APISessionDataPublisher = APISessionDataPublisher()
    
    /// Access token
    #if DEBUG
    var accessToken = UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? ""
    #else
    let fakeToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGFzay5odXVoaWVucXQuZGV2XC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTU4Nzk1MTYyOSwiZXhwIjoxNTg4NTU2NDI5LCJuYmYiOjE1ODc5NTE2MjksImp0aSI6IjFlczlhcDROS1lGWDlxVHAiLCJzdWIiOiIzNmU3NTkyMC04MTRiLTExZWEtYjQyZS05ZjIyMzYwZTVkZGUiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Tdr51v3TO4CqyuMrCUyoRsR9Ebsm2-8qaawPhEe7VY0"
    var accessToken = UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? fakeToken
    #endif
        
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
    
    private func request(url: URL, authen: Bool = false, headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = (headers != nil) ? headers : self.defaultHeaders
        request.timeoutInterval = timeoutInterval
        if authen {
            request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    internal func printJSON(data: Data?) {
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
    
    func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidRespond }
        
        guard httpResponse.statusCode != 401 else {
            NotificationCenter.default.post(name: .statusCode401, object: self)
            throw APIError.statusCode(httpResponse.statusCode)
        }
        self.printJSON(data: data)
        return data
    }
    
    internal func send(request: URLRequest) -> AnyPublisher<Entry<ResponseData>, Error> {
        return publisher
            .dataTaskPublisher(for: request)
            .tryMap { try self.validate($0.data, $0.response) }
            .decode(type: Entry<ResponseData>.self, decoder: self.defaultJSONDecoder )
            .eraseToAnyPublisher()
    }
    
    internal func getData(from url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        // Create a URL with parameters
        let url = self.parasWith(url: url, page: page, numberOfItems: numberOfItems, keyword: keyword)
        // Create a get request
        let request = self.getRequest(url: url, authen: true)
        return send(request: request)
    }
    
    private func parasWith(url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> URL {
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = []
        if let page = page {
            urlComponent.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let numberOfItems = numberOfItems {
            urlComponent.queryItems?.append(URLQueryItem(name: "limit", value: "\(numberOfItems)") )
        }
        if let keyword = keyword {
            urlComponent.queryItems?.append(URLQueryItem(name: "keyword", value: "\(keyword)") )
        }
        
        return urlComponent.url!
    }
}
