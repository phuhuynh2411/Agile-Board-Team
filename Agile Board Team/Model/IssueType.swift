//
//  IssueType.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class IssueType: Codable, Identifiable, ObservableObject, Equatable {
    @Published var id: String
    @Published var icon: String?
    @Published var name: String
    @Published var description: String?
    @Published var createdAt: Date
    @Published var updatedAt: Date?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        icon = try? container.decode(String.self, forKey: .icon)
        name = try container.decode(String.self, forKey: .name)
        description = try? container.decode(String.self, forKey: .description)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(icon, forKey: .icon)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case icon
        case name
        case description
        case createdAt
        case updatedAt
    }
    
    static func == (lhs: IssueType, rhs: IssueType) -> Bool {
          lhs.id == rhs.id
    }
}
