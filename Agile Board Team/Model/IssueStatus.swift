//
//  IssueStatus.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class IssueStatus:Codable {
    let id: String
    let name: String
    let icon: String?
    let color: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date
}
