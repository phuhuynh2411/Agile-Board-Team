//
//  Issue.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class Issue: Codable, Identifiable {
    var id: String
    var projectId: String
    var typeId: String
    var priorityId: String
    var statusId: String
    var userId: String
    var assigneeId: String
    var name: String
    var description: String?
    var startDate: Date?
    var endDate: Date?
    let createdAt: Date
    let updatedAt: Date
    let issueNumber: String
    
    var type: IssueType?
    var priority: IssuePriority?
    var status: IssueStatus?
    var project: Project
    var supporter: IssueReporter?
}
