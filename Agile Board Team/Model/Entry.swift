//
//  Entry.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

struct Entry<T: Codable>: Codable {
    let meta: MetaData
    let data: T?
    
    static func placeholder(message: String)-> Entry {
        return Entry(meta: MetaData(success: false, statusCode: 400, message: message, errors: nil), data: nil)
    }
    
    struct Empty: Codable {}
}
