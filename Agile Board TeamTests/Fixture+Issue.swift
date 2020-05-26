//
//  Fixture+Issue.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team

extension Fixture {
    
    static var issueEntryResponse401: Entry<APIIssue.ResponseData> {
        let meta = MetaData(success: false, statusCode: 401, message: "", errors: nil)
        let data: APIIssue.ResponseData = APIIssue.ResponseData(data: [])
        let entry: Entry<APIIssue.ResponseData> = Entry(meta: meta, data: data)
        return entry
    }
    
    static var issueEntryResponse200: Entry<APIIssue.ResponseData> {
        let meta = MetaData(success: false, statusCode: 200, message: "", errors: nil)
        let data: APIIssue.ResponseData = APIIssue.ResponseData(data: [])
        let entry: Entry<APIIssue.ResponseData> = Entry(meta: meta, data: data)
        return entry
    }
}
