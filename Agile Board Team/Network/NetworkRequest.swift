//
//  NetworkRequest.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

private let fakeToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGFzay5odXVoaWVucXQuZGV2XC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTU4Nzk1MTYyOSwiZXhwIjoxNTg4NTU2NDI5LCJuYmYiOjE1ODc5NTE2MjksImp0aSI6IjFlczlhcDROS1lGWDlxVHAiLCJzdWIiOiIzNmU3NTkyMC04MTRiLTExZWEtYjQyZS05ZjIyMzYwZTVkZGUiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Tdr51v3TO4CqyuMrCUyoRsR9Ebsm2-8qaawPhEe7VY0"

protocol NetworkRequest {}

extension NetworkRequest {
    #if DEBUG
    private var accessToken: String {
        UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? ""
    }
    #else
    private var accessToken: String {
        UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) ?? fakeToken
    }
    #endif
    
    var defaultHeaders: [String: String] {[
        "Content-Type": "application/json",
        "cache-control": "no-cache",
        ]}
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
           
    func postRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "POST"
        return request
    }
    
    func getRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "GET"
        return request
    }
    
    func putRequest(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "PUT"
        return request
    }
    
    private func request(url: URL, authen: Bool = false, headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = (headers != nil) ? headers : self.defaultHeaders
        if authen {
            request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func printJSON(data: Data?) {
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
}
