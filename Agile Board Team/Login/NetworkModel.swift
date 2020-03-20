//
//  NetworkModel.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/19/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import Combine

class NetworkModel<ResponseData:Codable>: ObservableObject, NetworkRequest {
    @Published var isFailed = false
    @Published var isSucceeded = false
    
    @Published var errorMessage = ""
    @Published var isInprogress = false
    @Published var isValidated = false
    
    var entry: Entry<ResponseData>?
    var cancelable: AnyCancellable?
    let appState = AppState.shared
    
    func send(request: URLRequest) -> AnyPublisher<Entry<ResponseData>, Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .map {
                self.printJSON(data: $0.data)
                return $0.data
        }
        .decode(type: Entry<ResponseData>.self, decoder: jsonDecoder )
        .eraseToAnyPublisher()
    }
    
    func completed(with error: Error) {
        print(error)
        self.toggle(with: false)
        self.errorMessage = error.localizedDescription
    }
    
    func completed(with entry: Entry<ResponseData>) {
        print(entry)
        self.entry = entry
        self.toggle(with: true)
    }
    
    func toggle(with status: Bool) {
        self.isSucceeded = status
        self.isFailed = !status
        self.isInprogress = false
    }

    func error(with message: String) {
        self.errorMessage = message
    }
    
    func displayProgressbar(_ status: Bool) {
        self.isInprogress = status
    }
}
