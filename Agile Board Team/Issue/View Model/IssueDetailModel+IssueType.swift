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
        private var listenStream: AnyCancellable?
        private var updateStream: AnyCancellable?
        
        @Published var isUpdating: Bool = false
        @Published var issueType: IssueType!
        @Published var error: Error?
        
        var issue: Issue
        
        init(issue: Issue) {
            self.issue = issue
            self.issueType = issue.type
            
            self.listen()
        }
        
        func listen() {
            self.listenStream = self.$issueType
                .compactMap {$0 != self.issue.type ? $0 : nil}
                .receive(on: RunLoop.main)
                .sink(receiveValue: { (issueType) in
                    self.isUpdating = true
                    self.update(issueType)
                })
        }
        
        func update(_ issueType: IssueType) {
            // Call the API to update the issue type
            let issueAPI = IssueAPI(issue: self.issue)
            self.updateStream = issueAPI.update(issueType: issueType)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self.error = error
                    case .finished: break
                    }
                    self.stopUpdating()
                }, receiveValue: { (entry) in
                    self.issue.type = issueType
                    self.stopUpdating()
                })
        }
        
        private func stopUpdating() {
            // Deplay 0.5 second before updating the UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isUpdating = false
            }
        }
    }
}
