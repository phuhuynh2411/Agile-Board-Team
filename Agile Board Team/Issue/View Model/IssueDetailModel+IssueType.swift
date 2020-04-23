//
//  IssueDetailModel+IssueType.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/22/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

extension IssueDetailModel {
    
    class IssueTypeModel: ObservableObject {
        private var cancelStream: AnyCancellable?
        
        @Published var isUpdating: Bool = false
        @Published var issueType: IssueType!
        var issue: Issue
        
        init(issue: Issue) {
            self.issue = issue
            self.issueType = issue.type
            
            self.listen()
        }
        
        func listen() {
            self.cancelStream = self.$issueType
                .compactMap {$0 != self.issue.type ? $0 : nil}
                .receive(on: RunLoop.main)
                .sink(receiveValue: { (issueType) in
                    self.isUpdating = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.issue.type = issueType
                        self.isUpdating = false
                    }
                })
        }
    }
}
