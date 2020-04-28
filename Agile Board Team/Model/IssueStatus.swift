//
//  IssueStatus.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueStatus: Codable, Equatable, Identifiable, ObservableObject {
    static func == (lhs: IssueStatus, rhs: IssueStatus) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var id: String
    @Published var name: String
    @Published var icon: String?
    @Published var color: String
    @Published var description: String?
    @Published var createdAt: Date
    @Published var updatedAt: Date
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case icon
        case color
        case description
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try? container.decode(String.self, forKey: .icon)
        color = try container.decode(String.self, forKey: .color)
        description = try? container.decode(String.self, forKey: .description)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(color, forKey: .color)
        try container.encode(description, forKey: .description)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
