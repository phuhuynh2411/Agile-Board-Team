//
//  IssueDetailModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueDetailModel: ObservableObject {
    @Published var issue: Issue
    @Published var priority: IssuePriority?
    
    init(issue: Issue) {
        self.issue = issue
        self.priority = issue.priority
    }
}
