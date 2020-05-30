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
    let assigneedId: String?
    let name: String?
    let description: String?
    let startDate: Date?
    let endDate: Date?
}
