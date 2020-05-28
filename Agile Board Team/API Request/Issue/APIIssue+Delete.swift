//
//  APIIssue+Delete.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension APIIssue {
    
    internal func buildDeleteIssueRequest(_ issue: Issue) -> URLRequest {
        let url = self.url.appendingPathComponent(issue.id)
        let request = self.deleteRequest(url: url, authen: true)
        return request
    }
    
    func delete(_ issue: Issue) -> AnyPublisher<Issue, Error> {
        let request = buildDeleteIssueRequest(issue)
        let response: AnyPublisher<Entry<DeleteIssueResponse>, Error> = self.send(request: request)
        // returns an issue if it has been deleted
        return response
            .map { self.replace(entry: $0, with: issue) }
            .eraseToAnyPublisher()
    }
    
    private func replace(entry: Entry<DeleteIssueResponse>, with issue: Issue) -> Issue {
        return issue
    }
    
    struct DeleteIssueResponse: Codable {}
}
