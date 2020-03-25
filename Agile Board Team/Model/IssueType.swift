//
//  IssueType.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class IssueType: Codable {
    let id: String
    let icon: String?
    let name: String
    let description: String?
    let createdAt: Date
    let updatedDate: Date?
}
