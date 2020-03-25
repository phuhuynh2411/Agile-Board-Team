//
//  Issue.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class Issue: Codable, Identifiable {
    let id: String
    let projectId: String
    let typeId: String
    let priorityId: String
    let statusId: String
    let userId: String
    let assigneeId: String
    let name: String
    let description: String?
    let startDate: Date?
    let endDate: Date?
    let createdAt: Date
    let updatedAt: Date
    let issueNumber: String
    
    var type: IssueType?
    var priority: IssuePriority?
    var status: IssueStatus?
}
