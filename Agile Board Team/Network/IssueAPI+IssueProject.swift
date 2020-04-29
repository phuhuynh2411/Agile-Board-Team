//
//  IssueAPI+IssueProject.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/29/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension IssueAPI {
    
    private func buildUpdateIssueProjectRequest(_ project: Project) -> URLRequest {
        print("URL: \(self.updateIssueURL)")
        print("Issue Project ID: \(project.id)")
        var request = self.putRequest(url: self.updateIssueURL, authen: true)
        
        let jsonBody = IssueProjectRequest(projectId: project.id)
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
    
    func update(_ project: Project) -> AnyPublisher<Entry<Issue>, Error>{
        let request = self.buildUpdateIssueProjectRequest(project)
        return self.send(request: request)
            .tryMap { try self.validateResponse(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    struct IssueProjectRequest: Codable {
        let projectId: String
    }
}
