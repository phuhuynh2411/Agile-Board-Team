//
//  RespondData.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

protocol ResponseData: Codable {
    associatedtype ItemData:Codable
    var data: [ItemData] { get set }
}
