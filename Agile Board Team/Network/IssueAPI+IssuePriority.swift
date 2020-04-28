//
//  IssueAPI+IssuePriority.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension IssueAPI {
    
    private func buildUpdateIssuePriorityRequest(_ issuePriority: IssuePriority) -> URLRequest {
        print("URL: \(self.updateIssueURL)")
        print("Issue Priority ID: \(issuePriority.id)")
        var request = self.putRequest(url: self.updateIssueURL, authen: true)
        
        let jsonBody = IssuePriorityRequest(priorityId: issuePriority.id)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(jsonBody) else {
            fatalError("Invalid body request")
        }
        request.httpBody = data
        print("Body request")
        self.printJSON(data: data)
        
        return request
    }
    
    func update(_ issuePriority: IssuePriority) -> AnyPublisher<Entry<Issue>, Error>{
        let request = self.buildUpdateIssuePriorityRequest(issuePriority)
        return self.send(request: request)
            .tryMap { try self.validateResponse(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    struct IssuePriorityRequest: Codable {
        let priorityId: String
    }
}
