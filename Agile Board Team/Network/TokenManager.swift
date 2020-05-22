//
//  Token.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/18/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

class TokenManager {
    static var shared = TokenManager()
    
    var userDefault: UserDefaults
    
    init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func setToken(_ token: String) {
        self.userDefault.set(token, forKey: UserDefaultKey.accessToken)
    }
    
    func getToken() -> String?{
        return self.userDefault.string(forKey: UserDefaultKey.accessToken)
    }
}

struct Token: Codable {
    var accessToken: String
}
