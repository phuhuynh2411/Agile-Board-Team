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
    
    init(selectedIssueType: Binding<IssueType?>? = nil) {
        self.selectedIssueType = selectedIssueType
        super.init()
    }
}

struct IssueTypeData: ResponseData {
    var data: [IssueType]
}
