//
//  IssuePriority.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssuePriority:Codable, Identifiable, Equatable {
    static func == (lhs: IssuePriority, rhs: IssuePriority) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let icon: String?
    let name: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date
    
    
}
