//
//  JSONDecoder_KeyDecodingStrategy+Extension.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/21/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy: Equatable {
    public static func == (lhs: JSONDecoder.KeyDecodingStrategy, rhs: JSONDecoder.KeyDecodingStrategy) -> Bool {
        switch(lhs, rhs) {
        case (.convertFromSnakeCase, .convertFromSnakeCase):
            return true
        case (.useDefaultKeys, .useDefaultKeys):
            return true
        default: return false
        }
    }
    
    
}
