//
//  APIError.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidRespond
    case invalidBody
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidEndPoint
    case statusCode(Int)
}

extension APIError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .statusCode(let code):
            guard code == 401 else { return "" }
            return NSLocalizedString("Session timeout. Need to re-login", comment: "")
        default: return ""
        }
    }
    
}
