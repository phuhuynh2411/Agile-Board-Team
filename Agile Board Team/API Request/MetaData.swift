//
//  MetaData.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

struct MetaData: Codable {
    let success: Bool
    let statusCode: Int
    let message: String
    
    let errors: [String: [String]]?
}
