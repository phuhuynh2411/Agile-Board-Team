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

class PriorityListModel: BaseListModel<IssuePriority, PriorityListModel.PriorityData> {
    override var url: URL { issuePriorityURL }
    
    override init() {
        super.init()
        _ = self.objectWillChange.append(super.objectWillChange)
        
        self.reload(animated: true)
    }
    
    init(priorities: [IssuePriority]) {
        super.init(items: priorities)
    }
    
    struct PriorityData: ResponseData {
        var data: [IssuePriority]
    }
}
