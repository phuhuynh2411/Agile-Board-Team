//
//  IssueStatusListModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueStatusListModel: BaseListModel<IssueStatus, IssueStatusData> {
    override var url: URL { URLSetting.issueStatusURL }
    var issue: Issue?
    
    var updateIssueStatusStream: AnyCancellable?
    
    init(issue: Issue?) {
        self.issue = issue
        super.init()
    }
    
    /**
     Call the API and update the issue status
     */
    func select(_ issueStatus: IssueStatus, _ callback: @escaping (_ dimissView: Bool)-> Void ) {
        // The issue is required before updating the issue type
        guard let issue = self.issue, issueStatus != issue.status else {
            callback(true)
            return
        }
        // Start progress bar
        self.isRefreshing = true
        
        let issueAPI = IssueAPI(issue)
        self.updateIssueStatusStream = issueAPI.update(issueStatus)
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
                self.issue?.status = issueStatus
            })
    }
}

struct IssueStatusData: ResponseData {
    var data: [IssueStatus]
}
