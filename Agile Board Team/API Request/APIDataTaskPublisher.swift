//
//  APIDataTaskPublisher.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 5/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

protocol APIDataTaskPublisher {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}
