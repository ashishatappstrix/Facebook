//
//  HomeDataSource.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/25/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation

enum ImageType: String {
    case Cover = "cover"
    case UserImage = "userImage"
}

struct UploadImageRequiredInfo {
    var userID: String
    var imgData : Data
    var imgType: ImageType
    init(userID: String, imgData: Data, imgType: ImageType) {
        self.userID = userID
        self.imgData = imgData
        self.imgType = imgType
        
    }
}

struct ImageUploadedResponse {
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
