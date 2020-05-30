//
//  Mock+Issue.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team

extension Mock {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    var validIssueJSON: String {
        """
        {
            "id": "id",
            "status_Id": "statusId",
            "user_Id": "userId",
            "assignee_Id": "assigneeId",
            "name": "issueName"
        }
        """
    }
    var validIssue: Issue {
        return try! decoder.decode(Issue.self, from: Data(validIssueJSON.utf8))
    }
    
    private var emptyStatusIssueJSON: String {
        """
        {
            "id": "id",
            "statusId": "",
            "userId": "userId",
            "assigneeId": "assigneeId",
            "name": "issueName"
        }
        """
    }
    
    var emptyStatusIssue: Issue {
        return try! decoder.decode(Issue.self, from: Data(emptyStatusIssueJSON.utf8))
    }
    
    private var emptyUserIdIssueJSON: String {
        """
        {
            "statusId": "statusId",
            "userId": "",
            "assigneeId": "assigneeId",
            "name": "issueName"
        }
        """
    }
    
    var emptyUserIdIssue: Issue {
        return try! decoder.decode(Issue.self, from: Data(emptyUserIdIssueJSON.utf8))
    }
    
    private var emptyAssigneeIdIssueJSON: String {
        """
        {
        "statusId": "statusId",
        "userId": "userId",
        "assigneeId": "",
        "name": "issueName"
        }
        """
    }
    
    var emptyAssigneeIdIssue: Issue {
        return try! decoder.decode(Issue.self, from: Data(emptyAssigneeIdIssueJSON.utf8))
    }
    
    private var emptyNameIssueJSON: String {
        """
        {
        "statusId": "statusId",
        "userId": "userId",
        "assigneeId": "",
        "name": "issueName"
        }
        """
    }
    
    var emptyNameIssue: Issue {
        return try! decoder.decode(Issue.self, from: Data(emptyNameIssueJSON.utf8))
    }
    
    var validAddIssueRepsonse: Entry<APIIssue.AddResponse> {
        let meta = MetaData(success: true, statusCode: 200, message: "", errors: nil)
        let data: APIIssue.AddResponse = APIIssue.AddResponse(data: validIssue)
        let entry: Entry<APIIssue.AddResponse> = Entry(meta: meta, data: data)
        return entry
    }
    
    var validUPdateIssueRepsonse: Entry<APIIssue.AddResponse> {
        let meta = MetaData(success: true, statusCode: 200, message: "", errors: nil)
        let data: APIIssue.AddResponse = APIIssue.AddResponse(data: validIssue)
        let entry: Entry<APIIssue.AddResponse> = Entry(meta: meta, data: data)
        return entry
    }
}
