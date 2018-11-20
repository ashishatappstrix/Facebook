//
//  AccountsDataSource.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/19/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation

struct LoginRequiredInfo {
    var userName : String
    var password : String
    init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
}

struct LoginResponse {
    var message : String?
    var statusCode : String?
    init(data: Dictionary<String, Any>) {
        print(data["status"])
        if let statusCode = data["status"] as? String, let message = data["message"] as? String {
            self.statusCode = statusCode
            self.message = message
        } else {
            self.statusCode = "400"
            self.message = "Invalid Data. Backend Error"
        }
    }
}

struct RegistrationRequiredInfo {
    
}
