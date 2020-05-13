//
//  NotificationCenter+Extension.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didLoginSucceed = Notification.Name("didLoginSucceed")
    static let issueDidChange = Notification.Name("issueDidChange")
    static let statusCode401 = Notification.Name("statusCode401")
}
