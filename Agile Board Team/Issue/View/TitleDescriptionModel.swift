//
//  TitleDescriptionModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import SwiftUI

class TitleDescriptionModel: ObservableObject {
    let issue: Issue
    
    @Published var name: String  = ""
    @Published var description: String = ""
    
    init(_ issue: Issue) {
        self.issue = issue
        
        self.name = issue.name
        self.description = issue.description ?? ""
    }
}
