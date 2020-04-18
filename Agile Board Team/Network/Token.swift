//
//  Token.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class Token: Codable {
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
