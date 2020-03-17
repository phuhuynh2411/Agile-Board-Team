//
//  TestModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class TestModelView: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var loginDisabled = true
    
    var loginRequest: AnyCancellable?
    
    var loginButtonStream: AnyCancellable?
    
    let url = "https://task.huuhienqt.dev/api/v1/login"
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        return $username.combineLatest($password) { username, password in
            guard username.count > 0, password.count > 0 else { return nil}
            return (username, password)
        }.eraseToAnyPublisher()
    }
    
    init() {
        self.loginButtonStream = self.validatedCredentials
            .map { $0 == nil }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: {
                    self.loginDisabled = $0
            })
    }
    
    func login() {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let json = [
            "username": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData

        loginRequest = URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map { $0.data }
            .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                print(error)
            }) { (entry) in
                print(entry)
        }
        
    }
    
    struct ResponseData: Codable {
        var accessToken: String
        var tokenType: String
        var expiresIn: Int
        var user: User
    }
}
