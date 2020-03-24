//
//  IssueListModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueListModel: ObservableObject {
    @Published var search = ""
    @Published var showCancelButton = false
    
    @Published var issues: [Issue] = []
    @Published var isShowing = false
    
    init(issues: [Issue]) {
        self.issues = issues
    }
}
