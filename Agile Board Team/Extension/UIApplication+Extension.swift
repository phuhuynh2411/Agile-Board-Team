//
//  UIApplication+Extension.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
