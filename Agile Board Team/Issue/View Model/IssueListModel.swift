//
//  IssueListModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueListModel: BaseListModel<Issue, IssueResponse> {
    override var url: URL { URLSetting.issueURL }
    @Published var issueDetailModel: IssueDetailModel!
    
    override init() {
        super.init()
         //_ = self.objectWillChange.append(super.objectWillChange)
        //self.reload()
        issueDetailModel = IssueDetailModel(issue: issueData[0])
    }
    
    init(issues: [Issue]) {
        super.init(items: issues)
    }
}

struct IssueResponse: ResponseData {
    var data: [Issue]
}
