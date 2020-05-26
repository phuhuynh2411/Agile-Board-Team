//
//  APIIssue+Get.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension APIIssue {
    
    /**
     Return a new URLRequest with query items added
     - Returns: new URLRequest
     */
    internal func buildGetIssuesRequest() -> URLRequest {
        let urlWithParas = addQueryItems(page: page, limit: limit, search: search, to: self.url)
        return getRequest(url: urlWithParas, authen: true)
    }
    
    /**
     Get a number of issues
     - Returns: A publisher with an optional arrray of issues as an output, and the error.
     */
    func getIssues() -> AnyPublisher<[Issue]?, Error> {
        let request = buildGetIssuesRequest()
        return self.send(request: request)
            .tryMap { try self.validate(entry: $0 ) }
            .compactMap { $0.data?.issue }
            .eraseToAnyPublisher()
    }
}
