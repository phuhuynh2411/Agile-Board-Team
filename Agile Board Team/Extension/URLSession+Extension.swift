//
//  URLSession+Extension.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completion: @escaping UploadTaskResult) -> URLSessionUploadTaskProtocol {
        return uploadTask(with: request, from: bodyData, completionHandler: completion) as URLSessionUploadTaskProtocol
    }
}
