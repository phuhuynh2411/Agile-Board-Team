//
//  IssueType.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class IssueType: Codable, Identifiable, Equatable {
    static func == (lhs: IssueType, rhs: IssueType) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let icon: String?
    var name: String
    let description: String?
    let createdAt: Date
    let updatedDate: Date?
}
