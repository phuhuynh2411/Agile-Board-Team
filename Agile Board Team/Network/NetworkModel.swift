//
//  NetworkModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

protocol NetworkModel: NetworkRequest {
    associatedtype ResponseData: Codable
    var entry: Entry<ResponseData>? { get set }
}

extension NetworkModel {
    
    func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let _ = response as? HTTPURLResponse else { throw APIError.invalidRespond }
        //guard (200...400).contains(httpResponse.statusCode) else { throw APIError.statusCode(httpResponse.statusCode)}
        self.printJSON(data: data)
        return data
    }
    
    func send(request: URLRequest) -> AnyPublisher<Entry<ResponseData>, Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap { try self.validate($0.data, $0.response) }
            .decode(type: Entry<ResponseData>.self, decoder: self.jsonDecoder )
            .eraseToAnyPublisher()
    }
    
    func getData(from url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        // Create a URL with parameters
        let url = self.parasWith(url: url, page: page, numberOfItems: numberOfItems, keyword: keyword)
        // Create a get request
        let request = self.getRequest(url: url, authen: true)
        return send(request: request)
    }
    
    func postData() {
        
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
