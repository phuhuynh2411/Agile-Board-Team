//
//  ContentModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {
    @Published var managedView: ManagedView = .login
    var loginStream: AnyCancellable?
    
    init() {
        loginStream = NotificationCenter.default.publisher(for: .didLoginSucceed)
            .receive(on: RunLoop.main)
            .compactMap {$0.userInfo?[UserDefaultKey.accessToken] as? String
        }
        .sink(receiveValue: { (value) in
            print("View router received notification value: \(value)")
            withAnimation {
                self.managedView = .main
            }
        })
    }
    
    enum ManagedView {
        case login
        case main
    }
}
