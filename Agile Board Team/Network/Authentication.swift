//
//  Authentication.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class Authentication: NetworkModel {
    
    var entry: Entry<Authentication.ResponseData>?
    static var shared = Authentication()
    
    private func buildLoginRequest(_ username: String, _ password: String) throws -> URLRequest {
        var request = self.postRequest(url: URLSetting.loginURL)
        let json = [
            "email": username,
            "password": password
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            throw APIError.invalidJSON
        }
        request.httpBody = jsonData
        
        return request
    }
    
    private func postLogin(_ username: String, _ password: String) -> AnyPublisher<Entry<ResponseData>, Error> {
        return Future<URLRequest, Error> { promise in
            do {
                let request = try self.buildLoginRequest(username, password)
                promise(.success(request))
            } catch {
                promise(.failure(error))
            }
        }
        .flatMap { self.send(request: $0) }
        .eraseToAnyPublisher()
    }
    
    func login(_ username: String, _ password: String) -> AnyPublisher<Token, Error> {
        return postLogin(username, password) // Entry/ Error
            .tryMap { try self.validateLogin(entry: $0) }
            .eraseToAnyPublisher()
    }
    
    private func validateLogin(entry: Entry<ResponseData>) throws -> Token {
        guard entry.meta.success, entry.meta.statusCode == 200 else {
            throw LoginError.invalidCredential(entry.meta.message)
        }
        guard let token = entry.data?.accessToken else {
            throw LoginError.emptyToken
        }
        // Save access token to the user default
        UserDefaults.standard.set(token, forKey: UserDefaultKey.accessToken)
        // Post a notification
        NotificationCenter.default.post(name: .didLoginSucceed, object: self, userInfo: [UserDefaultKey.accessToken: token])
        return Token(accessToken: token)
    }
    
    struct ResponseData: Codable {
           var accessToken: String
           var tokenType: String
           var expiresIn: Int
           var user: User
    }
    
    enum LoginError: Error, LocalizedError {
        case invalidCredential(String)
        case emptyToken
        
        var errorDescription: String? {
            switch self {
            case .invalidCredential(let errorMessage):
                return NSLocalizedString(errorMessage, comment: "")
            case .emptyToken:
                return NSLocalizedString("The access token is empty.", comment: "")
            }
        }
    }
}
