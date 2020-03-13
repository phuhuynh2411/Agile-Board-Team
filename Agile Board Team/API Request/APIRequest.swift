//
//  APIRequest.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 3/11/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class APIRequest {
    
    let session: URLSessionProtocol
    var baseURL: URL { URL(string: "https://task.huuhienqt.dev/")! }
    let jsonDecoder = JSONDecoder()
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func handel(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws {
                
        if let err = error { throw err }

        guard let response = response as? HTTPURLResponse, (200...499).contains(response.statusCode) else {
            throw RequestError.serverError
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
            throw RequestError.wrongMineType
        }
        
        self.printJSON(data: data)
        
        guard let data = data else { throw RequestError.emptyData }
        
        try self.parseJSON(with: data)
    }
    
    func parseJSON(with data: Data) throws {
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy  = .convertFromSnakeCase
    }
    
    func printJSON(data: Data?) {
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
    
    enum RequestError: Error {
        case serverError
        case wrongMineType
        case emptyData
    }
    
    struct MetaData: Codable {
        let success: Bool
        let statusCode: Int
        let message: String
        
        let errors: [String: [String]]?
    }

    struct Entry<T: Codable>: Codable {
        let meta: MetaData
        let data: T?
    }
}

extension APIRequest.RequestError: LocalizedError {
    var errorDescription : String? {
        switch self {
        case .serverError:
            return NSLocalizedString("Server error.", comment: "")
        case .wrongMineType:
            return NSLocalizedString("Wrong MINE type.", comment: "")
        case .emptyData:
            return NSLocalizedString("The response data is empty.", comment: "")
        }
    }
}


protocol URLSessionProtocol {
    typealias UploadTaskResult = (Data?, URLResponse?, Error?) -> Void
    func uploadTask(with request: URLRequest, from bodyData: Data?, completion: @escaping UploadTaskResult) -> URLSessionUploadTaskProtocol
}

protocol URLSessionUploadTaskProtocol {
    func resume()
}

