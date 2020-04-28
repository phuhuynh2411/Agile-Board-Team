//
//  IssueAPI.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueAPI: NetworkModel {
    var entry: Entry<Issue>?
    let issue: Issue
    var updateIssueURL: URL {
        URLSetting.issueURL.appendingPathComponent(issue.id)
    }
        
    init(_ issue: Issue) {
        self.issue = issue
    }
    
    internal func validateResponse(entry: Entry<Issue>) throws -> Entry<Issue> {
        print(entry)
        guard entry.meta.statusCode == 200 else {
            throw IssueAPIError.failure(entry.meta.message)
        }
        
        return entry
    }
    
//    struct IssueRespondData: ResponseData, Codable {
//       var data: Issue
//    }
    
    enum IssueAPIError: Error, LocalizedError {
        case failure(String)
        
        var errorDescription: String? {
            switch self {
            case .failure(let errorMessage):
                return NSLocalizedString(errorMessage, comment: "")
            }
        }
    }
}
