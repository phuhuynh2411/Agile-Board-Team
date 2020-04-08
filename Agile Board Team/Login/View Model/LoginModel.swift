//
//  TestModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class LoginModel: ObservableObject, NetworkModel {
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var isValidated = false
    @Published var isFailed = false
    @Published var isSucceeded = false
    
    @Published var errorMessage = ""
    @Published var isInprogress = false
    
    let appState = AppState.shared
    
    var loginButtonStream: AnyCancellable?
    var loginStream: AnyCancellable?
    var entry: Entry<LoginModel.ResponseData>?
    
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
    
    func signIn(animated: Bool = true) {
        if animated { self.isInprogress = true }
        var request = self.post(url: loginURL)
        let json = [
            "email": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData

        self.loginStream = self.send(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isFailed = true
                    self.errorMessage = error.localizedDescription
                }
            }) { (entry) in
                self.isInprogress = false
                if entry.meta.success && entry.meta.statusCode == 200 {
                    self.isSucceeded = true
                    self.startSession(with: entry)
                } else {
                    self.isFailed = true
                    self.errorMessage = entry.meta.message
                }
        }
    }
    
    func startSession(with entry: Entry<ResponseData>) {
        guard let data = entry.data else { return }
        let session = AppSession(
                        accessToken: data.accessToken,
                        tokenType: data.tokenType,
                        expiresIn: data.expiresIn)
        
        self.appState.session = session
        self.appState.user = data.user
        
        self.appState.viewRouter.managedView = .main
    }
    
    struct ResponseData: Codable {
        var accessToken: String
        var tokenType: String
        var expiresIn: Int
        var user: User
    }
}
