//
//  URLSessionMock.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/12/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    
    var uploadTask = MockURLSessionUploadTask()
    var jsonFileName: String?
    var urlResponse: URLResponse?
    var error: Error?
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completion: @escaping UploadTaskResult) -> URLSessionUploadTaskProtocol {
        var data: Data?
        if let filename = self.jsonFileName, let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                data = try Data(contentsOf:  URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                completion(nil, nil, error)
            }
        }
        completion(data, urlResponse, error)
        
        return uploadTask
    }
    
    enum SessionError: Error {
        case invalidJSONPath
    }
}
