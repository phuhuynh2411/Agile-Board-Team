//
//  JSONDecoder_DateDecodingStrategy+Extension.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/21/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy: Equatable {
    public static func == (lhs: JSONDecoder.DateDecodingStrategy, rhs: JSONDecoder.DateDecodingStrategy) -> Bool {
        switch (lhs, rhs) {
        case(.deferredToDate, .deferredToDate):
            return true
        case(.iso8601, .iso8601):
            return true
        case (.millisecondsSince1970, .millisecondsSince1970):
            return true
        case (.secondsSince1970, .secondsSince1970):
            return true
        case (.formatted(let date1), .formatted(let date2)):
            return date1 == date2
        default: return false
        }
        
    }
}
