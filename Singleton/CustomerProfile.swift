//
//  CustomerProfile.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/20/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation

class CustomerProfile {
private init() {}
    private static var _shared: CustomerProfile?
    public var userFirstName = String()
    public var userLastName = String()
    public var userBirthday = String()
    public var userGender = String()
    public var userEmail = String()
    public var userID = String()
    public var userCoverImageURL = String()
    public var userDisplayImageURL = String()
    
    public static var shared: CustomerProfile {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = CustomerProfile()
                    }
                }
            }
            return _shared!
        }
    }
}
