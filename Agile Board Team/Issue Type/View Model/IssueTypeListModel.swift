//
//  IssueTypeModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class IssueTypeListModel: BaseListModel<IssueType, IssueTypeData> {
    override var url: URL { issueTypeURL }
    @Published var selectedIssueType: IssueType?
    
    override init() {
        super.init()
        _ = self.objectWillChange.append(super.objectWillChange)
    }
    
    init(issueTypes: [IssueType]) {
        super.init(items: issueTypes)
    }
}

struct IssueTypeData: ResponseData {
    var data: [IssueType]
}
