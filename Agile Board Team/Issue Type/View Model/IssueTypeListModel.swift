//
//  IssueTypeModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class IssueTypeListModel: BaseListModel<IssueType, IssueTypeData> {
    override var url: URL { URLSetting.issueTypeURL }
    var issue: Issue?
    
    var updateIssueTypeStream: AnyCancellable?
    
    init(issue: Issue?) {
        self.issue = issue
        super.init()
    }
    
    /**
     Call the API and update the issue type
     */
    func select(_ issueType: IssueType, _ callback: @escaping (_ dimissView: Bool)-> Void ) {
        // The issue is required before updating the issue type
        guard let issue = self.issue, issueType != issue.type else {
            callback(true)
            return
        }
        // Start progress bar
        self.isRefreshing = true
        
        let issueAPI = IssueAPI(issue)
        self.updateIssueTypeStream = issueAPI.update(issueType: issueType)
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
                self.issue?.type = issueType
            })
    }
}

struct IssueTypeData: ResponseData {
    var data: [IssueType]
}
