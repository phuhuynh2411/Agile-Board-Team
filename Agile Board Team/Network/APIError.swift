//
//  APIError.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidRespond
    case invalidBody
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidEndPoint
    case statusCode(Int)
}
