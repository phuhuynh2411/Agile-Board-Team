//
//  ContentModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {
    
    @Published var managedView: ManagedView = .login
    
    static let shared = ViewRouter()
    
    enum ManagedView {
        case login
        case main
    }
    
}
