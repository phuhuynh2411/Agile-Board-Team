//
//  NetworkRequest.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

private let fakeToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGFzay5odXVoaWVucXQuZGV2XC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTU4NDU0OTgwOCwiZXhwIjoxNTg1MTU0NjA4LCJuYmYiOjE1ODQ1NDk4MDgsImp0aSI6IlNseXlaMjhmak9tWThlcFUiLCJzdWIiOiI4ZDdjNWFkMC02OTFhLTExZWEtYmIyNS0yNWMzYmVlMDA0MzciLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.4sxk1QQ7cAMhzHuMOcKBQW6ucQbWooq-EgwGatdceCI"

protocol NetworkRequest {
    func get()
    func add()
    func update()
    func delete()
}

extension NetworkRequest {
    
    var accessToken: String {
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
    
    func request(url: URL, authen: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if authen {
            request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
