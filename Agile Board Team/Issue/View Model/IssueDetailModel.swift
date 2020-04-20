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
    
    var priorityStream: AnyCancellable?
    var issueTypeStream: AnyCancellable?
    
    @Published var isUpdatingPriority: Bool = false
    
    @Published var editedIssueType: IssueType?
    @Published var isUpdatingIssueType: Bool = false
        
    init(issue: Issue) {
        self.issue = issue
        
        //priorityListModel.selectedPriority = issue.priority
        //issueTypeListModel.selectedIssueType = issue.type
        
//        self.priorityStream = priorityListModel.$selectedPriority
//            .compactMap { $0 != issue.priority ? $0 : nil }
//            .receive(on: RunLoop.main)
//            .sink(receiveValue: { (priority) in
//                print(priority.name)
//
//                self.isUpdatingPriority = true
//                print(self.issue.priority?.name ?? "")
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.issue.priority = priority
//                    self.isUpdatingPriority = false
//                }
//            })
        
//        self.issueTypeStream = issueTypeListModel.$selectedIssueType
//            .compactMap { $0 != issue.type ? $0 : nil }
//            .receive(on: RunLoop.main)
//            .sink(receiveValue: { (issueType) in
//                print(issue.name)
//
//                self.isUpdatingIssueType = true
//                print(self.issue.type?.name ?? "")
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.issue.type = issueType
//                    self.isUpdatingIssueType = false
//                }
//            })
    }
}
