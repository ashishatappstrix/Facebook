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
        if let statusCode = data["status"] as? String, let message = data["message"] as? String {
            self.statusCode = statusCode
            self.message = message
            let helper = Helper()
            helper.setCustomerProfile(with: data)
            if let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String, let birthDay = data["birthday"] as? String, let gender =  data["gender"] as? String, let email = data["email"] as? String {
                
                CustomerProfile.shared.userFirstName = firstName
                CustomerProfile.shared.userLastName = lastName
                CustomerProfile.shared.userBirthday = birthDay
                CustomerProfile.shared.userGender = gender
                CustomerProfile.shared.userEmail = email
                print("Module Manager: \(CustomerProfile.shared.userEmail)")
                
            }
        } else {
            self.statusCode = "400"
            self.message = "Invalid Data. Backend Error"
        }
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

struct RegistrationResponse {
    var message : String?
    var statusCode : String?
    init(data: Dictionary<String, Any>) {
        if let statusCode = data["status"] as? String, let message = data["message"] as? String {
            self.statusCode = statusCode
            self.message = message
        } else {
            self.statusCode = "400"
            self.message = "Invalid Data. Backend Error"
        }
    }
}
