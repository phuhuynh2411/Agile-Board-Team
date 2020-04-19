//
//  TestModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class LoginModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var isValidated = false
    @Published var isFailed = false
    @Published var isSucceeded = false
    
    @Published var errorMessage = ""
    @Published var isInprogress = false
        
    var loginButtonStream: AnyCancellable?
    var loginStream: AnyCancellable?
    
    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        return $username.combineLatest($password) { username, password in
            guard username.count > 0, password.count > 0 else { return nil }
            return (username, password)
        }.eraseToAnyPublisher()
    }
    
    init() {
        self.loginButtonStream = self.validatedCredentials
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: {
                    self.isValidated = $0
            })
    }
    
    func login() {
        self.isInprogress = true
        self.errorMessage = ""
        
        self.loginStream = Authentication.shared.login(username, password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                }
                self.isInprogress = false
            }, receiveValue: { (token) in
                self.isSucceeded = !token.accessToken.isEmpty
                self.errorMessage = ""
                print("The login was successful.")
            })
    }
}
