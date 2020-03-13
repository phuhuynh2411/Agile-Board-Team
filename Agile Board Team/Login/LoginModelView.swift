//
//  LoginModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Combine
import Foundation

class LoginModelView: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var loginDidFail = false
    @Published var loginDidSucceed = false
    @Published var errorMessage = ""
    @Published var isStarted = false
    
    var session: URLSessionProtocol = URLSession.shared
    var request: APILoginRequest?
    
    func login() {
        do {
            try self.validate()
            self.submit()
        } catch {
            self.loginDidFail = true
            errorMessage = error.localizedDescription
        }
    }
    
    func validate() throws {
        guard !username.isEmpty else { throw ValidatorError.emptyUsername }
        guard !password.isEmpty else { throw ValidatorError.emptyPassword }
    }
    
    func submit() {
        request = APILoginRequest(session: session)
        self.startProgressBar()
        
        request?.login(username, password) { (data, response, error) in
            do {
                try self.request?.isLoginSucceeded(data, response, error)
                self.completedLogin()
            } catch {
                self.completedLogin(with: error)
            }
            self.stopProgressBar()
        }
    }
    
    func startProgressBar() {
        self.isStarted = true
    }
    
    func stopProgressBar() {
        DispatchQueue.main.async {
            self.isStarted = false
        }
    }
    
    func completedLogin() {
       self.loginDidSucceed = true
       self.loginDidFail = false
    }
    
    func completedLogin(with error: Error) {
        DispatchQueue.main.async {
            self.loginDidFail = true
            self.errorMessage = error.localizedDescription
            print(error)
        }
    }
    
}


enum ValidatorError: Error {
    case emptyUsername
    case emptyPassword
}

extension ValidatorError: LocalizedError {
    var errorDescription : String? {
        switch self {
        case .emptyPassword:
            return NSLocalizedString("The password is empty.", comment: "")
        case .emptyUsername:
            return NSLocalizedString("The username is empty.", comment: "")
        }
    }
}
