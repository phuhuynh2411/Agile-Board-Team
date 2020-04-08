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
    override var url: URL { issuePriorityURL }
    
    @Published var selectedPriority: IssuePriority?
    
    override init() {
        super.init()
        _ = self.objectWillChange.append(super.objectWillChange)
        
    }
    
    init(priorities: [IssuePriority]) {
        super.init(items: priorities)
    }
}

struct PriorityData: ResponseData {
    var data: [IssuePriority]
}
