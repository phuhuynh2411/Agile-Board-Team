//
//  User.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class User: Codable {
    
    var id: Int
    var status: Int
    var isAdmin: Bool
    var gender: Int
    var isNotify: Bool
    var isBlocked: Bool
    var isOnline: Bool
    var firstname: String?
    var lastname: String?
    var name: String
    var email: String
    var emailVerifiedAt: Date
    var address: String?
    var avatar: String?
    var phoneNumber: String?
    var birthday: Date?
    var bio: String?
    var createdAt: Date
    var updatedAt: Date

}
