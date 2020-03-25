//
//  APISetting.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

protocol URLSetting {
    var baseURL: URL{ get }
    var loginURL: URL { get }
    var projectURL: URL { get }
    var issueURL: URL { get }
    var issuePriorityURL: URL { get }
}

extension URLSetting {
    var baseURL: URL { URL(string: "https://task.huuhienqt.dev")! }
    var loginURL: URL { baseURL.appendingPathComponent("api/v1/login") }
    var projectURL: URL { baseURL.appendingPathComponent("api/v1/projects") }
    var issueURL: URL { baseURL.appendingPathComponent("api/v1/issues") }
    var issuePriorityURL: URL { baseURL.appendingPathComponent("api/v1/issues/priorities") }
}
