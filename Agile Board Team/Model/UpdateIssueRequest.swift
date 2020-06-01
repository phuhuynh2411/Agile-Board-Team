//
//  UpdateIssue.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/30/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

struct UpdateIssueRequest: Codable {
    let projectId: String?
    let parentId: String?
    let categoryId: String?
    let typeId: String?
    let priorityId: String?
    let statusId: String?
    let assigneeId: String?
    let name: String?
    let description: String?
    let startDate: Date?
    let endDate: Date?
    
    init(projectId: String? = nil, parentId: String? = nil, categoryId: String? = nil, typeId: String? = nil, priorityId: String? = nil, statusId: String? = nil, assigneeId: String? = nil, name: String? = nil, description: String? = nil, startDate: Date? = nil, endDate: Date? = nil) {
        self.projectId = projectId
        self.parentId = parentId
        self.categoryId = categoryId
        self.typeId = typeId
        self.priorityId = priorityId
        self.statusId = statusId
        self.assigneeId = assigneeId
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
}
