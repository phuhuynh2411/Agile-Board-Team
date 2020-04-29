//
//  ProjectListModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ProjectListModel: BaseListModel<Project, ProjectResponse> {
    override var url: URL { URLSetting.projectURL }
    
    var project: Project?
    var issue: Issue?
    
    var updateIssueProjectStream: AnyCancellable?
    
    init(_ project: Project? = nil, issue: Issue? = nil) {
        self.project = project
        self.issue = issue
        super.init()
    }
    
    /**
     Call the API and update the issue project
     */
    func select(_ project: Project, _ callback: @escaping (_ dimissView: Bool)-> Void ) {
        // The issue is required before updating the issue type
        guard let issue = self.issue, project != issue.project else {
            callback(true)
            return
        }
        // Start progress bar
        self.isRefreshing = true
        
        let issueAPI = IssueAPI(issue)
        self.updateIssueProjectStream = issueAPI.update(project)
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
                self.issue?.project = project
            })
    }
}

struct ProjectResponse: ResponseData {
    var currentPage: Int
    var data: [Project]
    var perPage: Int
    var total: Int
}
