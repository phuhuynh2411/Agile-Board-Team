//
//  TestModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class TestModelView: BaseViewModel {
    
    @Published var username = ""
    @Published var password = ""
    
    var loginButtonStream: AnyCancellable?
    
    var url: URL { baseURL.appendingPathComponent("api/v1/login") }
    
    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        return $username.combineLatest($password) { username, password in
            guard username.count > 0, password.count > 0 else { return nil}
            return (username, password)
        }.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        
        self.loginButtonStream = self.validatedCredentials
            .map { $0 == nil }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: {
                    self.isValidated = $0
            })
    }
    
    func login() {
        self.startsRequest()
        
        var request = self.postRequest(url: self.url)
        let json = [
            "email": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData

        self.networkRequest = URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map {
                $0.data
            }
            .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.completed(with: error)
                }
            }) { (entry) in
                self.completed(with: entry)

        }
    }
    
    private func completed(with entry: Entry<ResponseData>) {
        print(entry)
        
        if entry.meta.success && entry.meta.statusCode == 200 {
            self.toggle(with: true)
            self.startSession(with: entry)
        } else {
            self.toggle(with: false)
            self.error(with: entry.meta.message)
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
