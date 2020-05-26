//
//  Fixture.swift
//  Agile Board TeamTests
//
//  Created by Huynh Tan Phu on 5/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
@testable import Agile_Board_Team

class Fixture {
    static var successAuthentication = """
        {
            "meta": {
                "success": true,
                "statusCode": 200,
                "message": "Success"
            },
            "data": {
                "access_token": "testingToken",
                "token_type": "bearer",
                "expires_in": 604800,
                "user": {
                    "id": "36e75920-814b-11ea-b42e-9f22360e5dde",
                    "status": 1,
                    "is_admin": true,
                    "gender": 0,
                    "is_notify": true,
                    "is_blocked": false,
                    "is_online": false,
                    "first_name": null,
                    "last_name": null,
                    "name": "Janiya Wisozk",
                    "email": "admin@gmail.com",
                    "email_verified_at": "2020-04-18T08:04:23+00:00",
                    "address": null,
                    "avatar": null,
                    "phone_number": null,
                    "birthday": null,
                    "bio": null,
                    "created_at": "2020-04-18T08:04:23+00:00",
                    "updated_at": "2020-04-18T08:04:23+00:00"
                }
            }
        }
    """
    
    static var emptyAccessToken = """
        {
            "meta": {
                "success": true,
                "statusCode": 200,
                "message": "Success"
            },
            "data": {
                "access_token": "",
                "token_type": "bearer",
                "expires_in": 604800,
                "user": {
                    "id": "36e75920-814b-11ea-b42e-9f22360e5dde",
                    "status": 1,
                    "is_admin": true,
                    "gender": 0,
                    "is_notify": true,
                    "is_blocked": false,
                    "is_online": false,
                    "first_name": null,
                    "last_name": null,
                    "name": "Janiya Wisozk",
                    "email": "admin@gmail.com",
                    "email_verified_at": "2020-04-18T08:04:23+00:00",
                    "address": null,
                    "avatar": null,
                    "phone_number": null,
                    "birthday": null,
                    "bio": null,
                    "created_at": "2020-04-18T08:04:23+00:00",
                    "updated_at": "2020-04-18T08:04:23+00:00"
                }
            }
        }
    """
    
    static var failureAuthentication400 = """
        {
            "meta": {
                "success": false,
                "statusCode": 400,
                "message": "The selected email is invalid.",
                "errors": {
                    "email": [
                        "The selected email is invalid."
                    ]
                }
            }
        }
    """
    
    struct DummyCodable: Codable {
        let id: String
    }
    
    static let dummyResponse = """
    {
        "id": "empty"
    }
    """
    
    static let emptyJSON = ""
    
    static var invalidCredential401: Entry<APIAuthentication.ResponseData> {
        let meta = MetaData(success: false, statusCode: 401, message: "", errors: nil)
        let data: APIAuthentication.ResponseData = APIAuthentication.ResponseData(accessToken: "", tokenType: "", expiresIn: 0)
        let entry: Entry<APIAuthentication.ResponseData> = Entry(meta: meta, data: data)
        return entry
    }

    static var emptyAccessToken200: Entry<APIAuthentication.ResponseData> {
           let meta = MetaData(success: true, statusCode: 200, message: "", errors: nil)
           let data: APIAuthentication.ResponseData = APIAuthentication.ResponseData(accessToken: "", tokenType: "", expiresIn: 0)
           let entry: Entry<APIAuthentication.ResponseData> = Entry(meta: meta, data: data)
           return entry
    }
    
    static let unauthorizedResponse401 = """
    {
        "meta": {
            "success": false,
            "statusCode": 401,
            "message": "Unauthorized"
        }
    }
    """
}
