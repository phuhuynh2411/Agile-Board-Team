//
//  Project.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class Project: Codable, Identifiable, ObservableObject {
    @Published var id: String
    @Published var categoryId: String?
    @Published var status: Int
    @Published var code: String?
    @Published var name: String
    @Published var image: String?
    @Published var description: String?
    @Published var createdAt: Date
    @Published var updatedAt: Date
    @Published var deletedAt: Date?
    
    enum CodingKeys: CodingKey {
        case id
        case categoryId
        case status
        case code
        case name
        case image
        case description
        case createdAt
        case updatedAt
        case deletedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        categoryId = try? container.decode(String.self, forKey: .categoryId)
        status = try container.decode(Int.self, forKey: .status)
        code = try? container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        image = try? container.decode(String.self, forKey: .image)
        description = try? container.decode(String.self, forKey: .description)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        deletedAt = try? container.decode(Date.self, forKey: .deletedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(status, forKey: .status)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(deletedAt, forKey: .deletedAt)
    }
}
