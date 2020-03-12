//
//  APILoginRequest.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class APILoginRequest: APIRequest {
    
    var loginURL: URL { baseURL.appendingPathComponent("api/v1/login") }
    var entry: Entry<ResponseData>?
    
    override init(session: URLSessionProtocol) {
        super.init(session: session)
    }
    
    func login(_ username: String, _ password: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // Request
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Body
        let json = [
            "email": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
    }
    
    override func parseJSON(with data: Data) throws {
        try super.parseJSON(with: data)
        self.entry = try jsonDecoder.decode(Entry<ResponseData>.self, from: data)
    }
    
    func isLoginSucceeded(_ data: Data?,_ response: URLResponse?, _ error: Error?) throws {
        try handel(data, response, error)
        if  let entry = self.entry{
            guard entry.meta.success && entry.meta.statusCode == 200 else { throw RequestError.invalidCredentials }
        }
    }
    
    struct ResponseData: Codable {
        var accessToken: String
        var tokenType: String
        var expiresIn: Int
        var user: User
    }
    
    enum RequestError: Error, LocalizedError {
        case invalidCredentials
        
        var errorDescription : String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("The email or password is incorrect.", comment: "")
            }
        }
    }
    
}
