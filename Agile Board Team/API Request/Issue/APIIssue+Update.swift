//
//  APIIssue+Update.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension APIIssue {
    
    internal func buildUpdateIssueRequest(id: String, requestBody: UpdateIssueRequest) -> URLRequest {
        var request = self.putRequest(url: self.url.appendingPathComponent(id), authen: true)
        let httpBody = try! defaultJSONEncoder.encode(requestBody)
        request.httpBody = httpBody
        return request
    }
    
    func updateIssue(id: String, requestBody: UpdateIssueRequest) -> AnyPublisher<Issue, Error> {
        let request = buildUpdateIssueRequest(id: id, requestBody: requestBody)
        let response: AnyPublisher<Entry<Issue>, Error> = send(request: request)
        
        return response.compactMap { $0.data }
            .eraseToAnyPublisher()
    }

    struct UpdateIssueResponse: Codable {
        let data: Issue
    }
    
}
