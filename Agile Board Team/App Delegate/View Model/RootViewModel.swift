//
//  ContentModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject {
    @Published var managedView: ManagedView = .login
    var loginStream: AnyCancellable?
    var reloginStream: AnyCancellable?
    
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
        
        reloginStream = NotificationCenter.default.publisher(for: .statusCode401)
            .delay(for: 3.0, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (output) in
                print("The session has been timeout. Need to re-login.")
                withAnimation {
                    self.managedView = .login
                }
            })
        
        // Determine where to go
        self.whereToGo()
    }
    
    enum ManagedView {
        case login
        case main
    }
    
    private func whereToGo() {
        // If the access token is empty, the first view should be the login view
        // ; otherwise, go to the main view
        let accessToken = UserDefaults.standard.string(forKey: UserDefaultKey.accessToken)
        if accessToken != nil {
            managedView = .login
        } else {
            managedView = .main
        }
    }
}
