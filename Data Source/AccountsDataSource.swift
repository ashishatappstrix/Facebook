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

struct RegistrationRequiredInfo {
    var email: String
    var firstName: String
    var lastName: String
    var password: String
    var birthDay: String
    var gender: Int
    init(email: String, firstName: String, lastName: String, password: String, birthDay: String, gender: Int) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.birthDay = birthDay
        self.gender = gender
    }
}

struct LoginResponse {
    var message : String?
    var statusCode : String?
    init(data: Dictionary<String, Any>) {
        if let statusCode = data["status"] as? String, let message = data["message"] as? String {
            self.statusCode = statusCode
            self.message = message
            Helper.setCustomerProfile(with: data)
        } else {
            self.statusCode = "400"
            self.message = "Invalid Data. Backend Error"
        }
    }
}

struct RegistrationResponse {
    var message : String?
    var statusCode : String?
    init(data: Dictionary<String, Any>) {
        if let statusCode = data["status"] as? String, let message = data["message"] as? String {
            self.statusCode = statusCode
            self.message = message
            Helper.setCustomerProfile(with: data)
        } else {
            self.statusCode = "400"
            self.message = "Invalid Data. Backend Error"
        }
    }
}
