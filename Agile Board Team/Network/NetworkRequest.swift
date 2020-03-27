//
//  NetworkRequest.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

private let fakeToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGFzay5odXVoaWVucXQuZGV2XC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTU4NTEwNTEzNiwiZXhwIjoxNTg1NzA5OTM2LCJuYmYiOjE1ODUxMDUxMzYsImp0aSI6IlMxSXpxa2VVcXR5dWJUVW4iLCJzdWIiOiI3ZjY0ZmI1MC02ZTQzLTExZWEtOGM4OC0xMWY5MmRjYWNhMmEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.xRIn0jYReLCCO9I1OVglPX3ae01X1YFfPDpzX3Pg5ys"

protocol NetworkRequest {}

extension NetworkRequest {
    
    private var accessToken: String {
        AppState.shared.session?.accessToken ?? fakeToken
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
           
    func post(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "POST"
        return request
    }
    
    func get(url: URL, authen: Bool = false) -> URLRequest {
        var request = self.request(url: url, authen: authen)
        request.httpMethod = "GET"
        return request
    }
    
    private func request(url: URL, authen: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
