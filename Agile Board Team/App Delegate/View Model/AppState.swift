//
//  AppState.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class AppState {    
    var user: User?
    var session: AppSession?
    
    static let shared = AppState()
}
