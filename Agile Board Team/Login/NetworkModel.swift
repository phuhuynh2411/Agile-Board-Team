//
//  NetworkModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

protocol NetworkModel: NetworkRequest, URLSetting, ObservableObject {
    associatedtype ResponseData:Codable
    var entry: Entry<ResponseData>? {get set}
}

extension NetworkModel {
    
    func send(request: URLRequest) -> AnyPublisher<Entry<ResponseData>, Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .map {
                self.printJSON(data: $0.data)
                return $0.data
        }
        .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder )
        .eraseToAnyPublisher()
    }
    
    func get(from url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
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
    
        let request = self.get(url: urlComponent.url!, authen: true)
        return send(request: request)
    }
}
