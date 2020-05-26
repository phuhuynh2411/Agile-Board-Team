//
//  APIIssue.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class APIIssue: API<Entry<APIIssue.ResponseData>> {
    var url: URL
    var page: Int?
    var limit: Int?
    var search: String?
        
    init(url: URL = URLSetting.issueURL, page: Int? = 1, limit: Int? = 1, search: String? = nil) {
        self.url = url
        self.page = page
        self.limit = limit
        self.search = search
    }
    
    struct ResponseData: Codable {
        let data: [Issue]
    }
    
    internal func validate(entry: Entry<APIIssue.ResponseData>) throws -> Entry<APIIssue.ResponseData> {
        guard entry.meta.statusCode == 200 else {
            throw IssueAPIError.failure(entry.meta.message)
        }
        return entry
    }
    
    enum IssueAPIError: Error, LocalizedError, Equatable {
        case failure(String)
        
        var errorDescription: String? {
            switch self {
            case .failure(let errorMessage):
                return NSLocalizedString(errorMessage, comment: "")
            }
        }
    }
}
