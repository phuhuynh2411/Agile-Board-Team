//
//  ModelView.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

private let fakeToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGFzay5odXVoaWVucXQuZGV2XC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTU4NDU0OTgwOCwiZXhwIjoxNTg1MTU0NjA4LCJuYmYiOjE1ODQ1NDk4MDgsImp0aSI6IlNseXlaMjhmak9tWThlcFUiLCJzdWIiOiI4ZDdjNWFkMC02OTFhLTExZWEtYmIyNS0yNWMzYmVlMDA0MzciLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.4sxk1QQ7cAMhzHuMOcKBQW6ucQbWooq-EgwGatdceCI"

class BaseViewModel: ObservableObject {
    
    @Published var isValidated = true
    @Published var isFailed = false
    @Published var isSucceeded = false
    
    @Published var errorMessage = ""
    @Published var isInprogress = false
    
    var networkRequest: AnyCancellable?
    
    let baseURL = URL(string: "https://task.huuhienqt.dev")!
    
    let appState = AppState.shared
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
           
    func postRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getRequest(url: URL, addAuthenticationHeader: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if addAuthenticationHeader {
            request.setValue("Bearer \(self.appState.session?.accessToken ?? fakeToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func completed(with error: Error) {
        print(error)
        self.toggle(with: false)
        self.errorMessage = error.localizedDescription
    }
    
    func toggle(with status: Bool) {
        self.isSucceeded = status
        self.isFailed = !status
        self.isInprogress = false
    }
    
    func displaysProgressBar() {
        self.isInprogress = true
    }
    
    func error(with message: String) {
        self.errorMessage = message
    }
    
    func printJSON(data: Data?) {
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
}
