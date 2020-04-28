//
//  PriorityListModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PriorityListModel: BaseListModel<IssuePriority, PriorityData> {
    override var url: URL { URLSetting.issuePriorityURL }
    var issue: Issue?
    
    var updateIssuePriorityStream: AnyCancellable?
    
    init(_ issue: Issue?) {
        self.issue = issue
        super.init()
    }
    
    init(priorities: [IssuePriority]) {
        super.init(items: priorities)
    }
    
    /**
     Call the API and update the issue priority
     */
    func select(_ issuePriority: IssuePriority, _ callback: @escaping (_ dimissView: Bool)-> Void ) {
        // The issue is required before updating the issue type
        guard let issue = self.issue, issuePriority != issue.priority else {
            callback(true)
            return
        }
        // Start progress bar
        self.isRefreshing = true
        
        let issueAPI = IssueAPI(issue)
        self.updateIssuePriorityStream = issueAPI.update(issuePriority)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                self.isRefreshing = false
                switch completion {
                case .failure(let error):
                    print(error)
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                    callback(false)
                    return
                case .finished: break
                }
                callback(true)
            }, receiveValue: { (entry) in
                self.issue?.priority = issuePriority
            })
    }
}

struct PriorityData: ResponseData {
    var data: [IssuePriority]
}
