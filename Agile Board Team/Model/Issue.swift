//
//  Issue.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/23/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class Issue: Codable, Identifiable, ObservableObject {
    @Published var id: String
    @Published var projectId: String?
    @Published var typeId: String?
    @Published var priorityId: String?
    @Published var statusId: String
    @Published var userId: String
    @Published var assigneeId: String?
    @Published var name: String
    @Published var description: String?
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var createdAt: Date?
    @Published var updatedAt: Date?
    @Published var issueNumber: String?
    
    @Published var type: IssueType?
    @Published var priority: IssuePriority?
    @Published var status: IssueStatus?
    @Published var project: Project?
    @Published var supporter: IssueReporter?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        projectId = try? container.decode(String.self, forKey: .projectId)
        typeId = try? container.decode(String.self, forKey: .typeId)
        priorityId = try? container.decode(String.self, forKey: .priorityId)
        statusId = try container.decode(String.self, forKey: .statusId)
        userId = try container.decode(String.self, forKey: .userId)
        assigneeId = try? container.decode(String.self, forKey: .assigneeId)
        
        name = try container.decode(String.self, forKey: .name)
        description = try? container.decode(String.self, forKey: .description)
        startDate = try? container.decode(Date.self, forKey: .startDate)
        endDate = try? container.decode(Date.self, forKey: .endDate)
        createdAt = try? container.decode(Date.self, forKey: .createdAt)
        updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        issueNumber = try? container.decode(String.self, forKey: .issueNumber)
        type = try? container.decode(IssueType.self, forKey: .type)
        priority = try? container.decode(IssuePriority.self, forKey: .priority)
        status = try? container.decode(IssueStatus.self, forKey: .status)
        project = try? container.decode(Project.self, forKey: .project)
        supporter = try? container.decode(IssueReporter.self, forKey: .supporter)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(projectId, forKey: .projectId)
        try container.encode(typeId, forKey: .typeId)
        try container.encode(priorityId, forKey: .priorityId)
        try container.encode(statusId, forKey: .statusId)
        try container.encode(userId, forKey: .userId)
        try container.encode(assigneeId, forKey: .assigneeId)
        
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(issueNumber, forKey: .issueNumber)
        try container.encode(type, forKey: .type)
        try container.encode(priority, forKey: .priority)
        try container.encode(status, forKey: .status)
        try container.encode(project, forKey: .project)
        try container.encode(supporter, forKey: .supporter)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case projectId
        case typeId
        case priorityId
        case statusId
        case userId
        case assigneeId
        case name
        case description
        case startDate
        case endDate
        case createdAt
        case updatedAt
        case issueNumber
        case type
        case priority
        case status
        case project
        case supporter
    }
}
