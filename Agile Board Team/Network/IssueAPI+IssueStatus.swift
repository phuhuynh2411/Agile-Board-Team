//
//  IssueAPI+IssueStatus.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

import Combine

extension IssueAPI {
    
    private func buildUpdateIssueStatusRequest(_ issueStatus: IssueStatus) -> URLRequest {
        print("URL: \(self.updateIssueURL)")
        print("Issue Status ID: \(issueStatus.id)")
        var request = self.putRequest(url: self.updateIssueURL, authen: true)
        
        let jsonBody = IssueStatusRequest(statusId: issueStatus.id)
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
    
    func update(_ issueStatus: IssueStatus) -> AnyPublisher<Entry<Issue>, Error>{
        let request = self.buildUpdateIssueStatusRequest(issueStatus)
        return self.send(request: request)
            .tryMap { try self.validateResponse(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    struct IssueStatusRequest: Codable {
        let statusId: String
    }
}
