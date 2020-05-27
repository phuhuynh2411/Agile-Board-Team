//
//  APIIssue+Add.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension APIIssue {
    typealias AddReponseEntry = Entry<AddResponse>
    
    internal func buildAddIssueRequest(_ issue: Issue) -> URLRequest {
        var request = self.postRequest(url: url, authen: true)
        let jsonData = try! defaultJSONEncoder.encode(issue)
        request.httpBody = jsonData
        
        return request
    }
    
    func add(_ issue: Issue) -> AnyPublisher<Issue, Error>{
        let request = buildAddIssueRequest(issue)
        let response: AnyPublisher<AddReponseEntry, Error> = self.send(request: request)
        
        return response
            .compactMap { $0.data?.data }
            .eraseToAnyPublisher()
    }
    
    struct AddResponse: Codable {
        let data: Issue
    }
}
