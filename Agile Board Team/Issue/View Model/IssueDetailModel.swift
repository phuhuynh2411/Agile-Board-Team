//
//  IssueDetailModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class IssueDetailModel: ObservableObject {
    @Published var issue: Issue
    
    @Published var isFailed: Bool = false
    @Published var errorMessage: String = ""
    
    var issueTypeModel: IssueDetailModel.IssueTypeModel!
    
    var forwardChange: AnyCancellable?
    
    init(issue: Issue) {
        self.issue = issue
        issueTypeModel = IssueTypeModel(issue: issue)
        issueTypeModel.$error.sink { (error) in
            self.isFailed = true
            self.errorMessage = error?.localizedDescription ?? ""
        }
        
        // Forward the changes from nested class
        self.forwardChange = issueTypeModel.$isUpdating
            .sink(receiveValue: { _issue in
            self.objectWillChange.send()
        })
    }
}
