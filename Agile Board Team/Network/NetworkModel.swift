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
            .map {
                self.printJSON(data: $0.data)
                return $0.data
        }
        .decode(type: Entry<ResponseData>.self, decoder: self.jsonDecoder )
        .eraseToAnyPublisher()
    }
    
    func search(request: URLRequest) -> AnyPublisher<Entry<ResponseData>, Error> {
        return send(request: request)
            .catch{ error in
                Just(Entry.placeholder(message: error.localizedDescription))
                    .setFailureType(to: Error.self)
        }
        .eraseToAnyPublisher()
    }
    
    func getData(from url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        let request = self.parasWith(url: url, page: page, numberOfItems: numberOfItems, keyword: keyword)
        return send(request: request)
    }
    
    func searchData(from url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> AnyPublisher<Entry<ResponseData>, Error> {
        let request = self.parasWith(url: url, page: page, numberOfItems: numberOfItems, keyword: keyword)
        return search(request: request)
    }
    
    private func parasWith(url: URL, page: Int? = nil, numberOfItems: Int? = nil, keyword: String? = nil) -> URLRequest {
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
        
        return self.get(url: urlComponent.url!, authen: true)
    }
    
}
