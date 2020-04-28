//
//  IssueAPI+TitleDescription.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension IssueAPI {
    
    private func buildNameDescriptionRequest(_ name: String, _ description: String) -> URLRequest {
        print("URL: \(self.updateIssueURL)")
        print("New Issue Name: \(name)")
        print("New Issue Description: \(description)")
        
        var request = self.putRequest(url: self.updateIssueURL, authen: true)
        
        let jsonBody = NameDescriptionRequest(name: name, description: description)
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
    
    func update(name: String, description: String) -> AnyPublisher<Entry<Issue>, Error>{
        let request = self.buildNameDescriptionRequest(name, description)
        return self.send(request: request)
            .tryMap { try self.validateResponse(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    struct NameDescriptionRequest: Codable {
        let name: String
        let description: String
    }
    
}
