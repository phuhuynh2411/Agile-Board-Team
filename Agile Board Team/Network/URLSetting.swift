//
//  APISetting.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class URLSetting {
    static var baseURL: URL { URL(string: "https://task.huuhienqt.dev")! }
    static var loginURL: URL { baseURL.appendingPathComponent("api/v1/login") }
    static var projectURL: URL { baseURL.appendingPathComponent("api/v1/projects") }
    static var issueURL: URL { baseURL.appendingPathComponent("api/v1/issues") }
    static var issuePriorityURL: URL { baseURL.appendingPathComponent("api/v1/issues/priorities") }
    static var issueTypeURL: URL { baseURL.appendingPathComponent("api/v1/issues/types")}
}
