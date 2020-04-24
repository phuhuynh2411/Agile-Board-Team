//
//  IssueAPI+IssueType.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension IssueAPI {
    
    private func buildUpdateIssueTypeRequest(_ issueType: IssueType) -> URLRequest {
        print("URL: \(self.updateIssueTypeURL)")
        print("Issue Type ID: \(issueType.id)")
        var request = self.putRequest(url: self.updateIssueTypeURL, authen: true)
        
        let jsonBody = IssueTypeRequest(typeId: issueType.id)
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
    
    func update(issueType: IssueType) -> AnyPublisher<Entry<Issue>, Error>{
        let request = self.buildUpdateIssueTypeRequest(issueType)
        return self.send(request: request)
            .tryMap { try self.validateResponse(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    struct IssueTypeRequest: Codable {
        let typeId: String
    }
}
