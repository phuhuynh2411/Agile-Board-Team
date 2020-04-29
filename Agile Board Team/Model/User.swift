//
//  User.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class User: Codable, Equatable, ObservableObject {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var id: String
    @Published var firstname: String?
    @Published var lastname: String?
    @Published var name: String
    @Published var email: String
    @Published var avatar: String?
    @Published var phoneNumber: String?
    @Published var createdAt: Date
    @Published var updatedAt: Date
    
    enum CodingKeys: CodingKey {
        case id
        case firstname
        case lastname
        case name
        case email
        case avatar
        case phoneNumber
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        firstname = try? container.decode(String.self, forKey: .firstname)
        lastname = try? container.decode(String.self, forKey: .lastname)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        avatar = try? container.decode(String.self, forKey: .avatar)
        phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
