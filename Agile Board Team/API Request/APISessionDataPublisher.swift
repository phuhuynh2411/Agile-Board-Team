//
//  APISessionDataPublisher.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class APISessionDataPublisher: APIDataTaskPublisher {
    
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}
