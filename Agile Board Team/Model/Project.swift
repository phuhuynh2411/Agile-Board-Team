//
//  Project.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class Project: Codable, Identifiable {
    let id: String
    let categoryId: String?
    let status: Int
    let code: String?
    let name: String
    let image: String?
    let description: String?
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
}
