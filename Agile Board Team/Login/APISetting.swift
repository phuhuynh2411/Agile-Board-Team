//
//  APISetting.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class APISetting {
    let baseURL = URL(string: "https://task.huuhienqt.dev")!
    var loginURL: URL { baseURL.appendingPathComponent("api/v1/login") }
    var projectURL: URL { baseURL.appendingPathComponent("api/v1/projects") }
}
