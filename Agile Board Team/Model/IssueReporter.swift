//
//  Reporter.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class IssueReporter:Codable {
    let id: String
    let name: String
    let email: String
    let avatar: String?
}
/*
 "supporter": {
     "id": "7f9a25c0-6e43-11ea-9ec3-a57aaa82286d",
     "status": 1,
     "is_admin": false,
     "gender": 0,
     "is_notify": true,
     "is_blocked": false,
     "is_online": false,
     "first_name": null,
     "last_name": null,
     "name": "Leann Grady",
     "email": "reyes.gaylord@example.org",
     "email_verified_at": "2020-03-25T02:51:17+00:00",
     "address": null,
     "avatar": null,
     "phone_number": null,
     "birthday": null,
     "bio": null,
     "created_at": "2020-03-25T02:51:17+00:00",
     "updated_at": "2020-03-25T02:51:17+00:00"
 },
 */
