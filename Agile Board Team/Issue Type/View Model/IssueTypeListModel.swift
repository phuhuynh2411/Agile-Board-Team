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
    var selectedIssueType: Binding<IssueType?>?
    /// The issue will be updated
    var willUpdatedIssue: Issue?
    var updateIssueTypeStream: AnyCancellable?
    
    init(selectedIssueType: Binding<IssueType?>? = nil, willUpdated issue: Issue? = nil) {
        self.selectedIssueType = selectedIssueType
        self.willUpdatedIssue = issue
        super.init()
    }
    
    /**
     Call the API and update the issue type
     */
    func select(_ issueType: IssueType, _ callback: @escaping (_ dimiss: Bool)-> Void ) {
        // The issue is required before updating the issue type
        guard let issue = willUpdatedIssue, issueType != willUpdatedIssue?.type else {
            callback(true)
            return
        }
        // Start progress bar
        self.isRefreshing = true
        
        let issueAPI = IssueAPI(issue: issue)
        self.updateIssueTypeStream = issueAPI.update(issueType: issueType)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                case .finished: break
                }
                self.isRefreshing = false
                callback(false)
            }, receiveValue: { (entry) in
                self.selectedIssueType?.wrappedValue = issueType
                self.isRefreshing = false
                callback(true)
            })
    }
}

struct IssueTypeData: ResponseData {
    var data: [IssueType]
}
