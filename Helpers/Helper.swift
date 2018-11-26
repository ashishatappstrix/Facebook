//
//  Helper.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/16/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class Helper {
    
    // validate email address function / logic
    func isValid(email: String) -> Bool {
        
        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: email)
        
        return result
    }
    
    
    // validate name function / logic
    func isValid(name: String) -> Bool {
        
        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
        let regex = "[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        
        return result
    }
    
    // show alert message to the user
    func showAlert(title: String, message: String, in vc: UIViewController) {
        
        // creating alertController; creating button to the alertController; assigning button to alertController; presenting alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    // allows us to go to another ViewController programmatically
    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?) {
        
        // accessing any ViewController from Main.storyboard via ID
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        // presenting accessed ViewController
        vc.present(newViewController, animated: animated, completion: completion)
        
    }
    
    // MIME for the Image
    func body(with parameters: [String: Any]?, filename: String, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        // MIME Type for Parameters [id: 777, name: michael]
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        
        // MIME Type for Image
        let mimetype = "image/jpg"
        
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        
        body.append(imageDataKey)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    
    /**
     This method is used to get Device IP Address
     */
    class func getDeviceIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6), let name: String = String(cString: (interface?.ifa_name)!), name == "en0" || name == "pdp_ip0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    class func bindCurrentUserToCustomerProfile() {
        guard let currentUser = UserDefaults.standard.object(forKey: FBConstants.userDefaultsKey) as? Dictionary<String, Any> else {
            return
        }
        
        self.setCustomerProfile(with: currentUser)
        
    }
    
    class func setCustomerProfile(with data: Dictionary<String, Any>) {
        if let userID = data["id"] as? String, let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String, let birthDay = data["birthday"] as? String, let gender =  data["gender"] as? String, let email = data["email"] as? String {
            CustomerProfile.shared.userID = userID
            CustomerProfile.shared.userFirstName = firstName
            CustomerProfile.shared.userLastName = lastName
            CustomerProfile.shared.userBirthday = birthDay
            CustomerProfile.shared.userGender = gender
            CustomerProfile.shared.userEmail = email
        }
        
        if let coverImage = data["cover"] as? String {
            CustomerProfile.shared.userCoverImageURL = coverImage
        }
        if let userDP = data["userImage"] as? String {
            CustomerProfile.shared.userDisplayImageURL = userDP
        }
        
        if let _ = UserDefaults.standard.object(forKey: FBConstants.userDefaultsKey) as? NSMutableDictionary {
            UserDefaults.standard.removeObject(forKey: FBConstants.userDefaultsKey)
            UserDefaults.standard.set(data, forKey: FBConstants.userDefaultsKey)
            UserDefaults.standard.synchronize()
            
        } else {
            UserDefaults.standard.set(data, forKey: FBConstants.userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
}

extension Date
{
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

