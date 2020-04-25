//
//  IssueDetailModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class IssueDetailModel: ObservableObject {
    var issue: Issue
    
    init(_ issue: Issue) {
        self.issue = issue

    }
}
