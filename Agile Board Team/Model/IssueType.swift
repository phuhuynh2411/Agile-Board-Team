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

/*
 "type": {
    "id": "69da6630-6dcc-11ea-bd19-cd4a328a3450",
    "parent_id": null,
    "status": 1,
    "icon": "https://task.huuhienqt.dev/images/issue-type/story.svg",
    "name": "Story",
    "description": "Illum qui optio atque sit nemo sed autem. Eos est dolores dolorum aliquid. Est commodi et nisi praesentium et assumenda.",
    "created_at": "2020-03-24T12:38:50+00:00",
    "updated_at": "2020-03-24T12:38:50+00:00"
 },
 */
