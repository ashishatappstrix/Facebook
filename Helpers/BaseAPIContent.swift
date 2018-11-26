//
//  BaseAPIContent.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/19/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation
typealias Response = (_ response: Any, _ error: Error?) -> Void
enum TriggerAPIFor {
    case login
    case register
    case uploadImage
    case updateBio
}

enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

class APIRequestHandler {
    
    func trigger(APIfor: TriggerAPIFor, data: Any, completion: @escaping Response) {
        if (APIfor == .login && (data as? LoginRequiredInfo != nil)) {
            guard let urlRequest = self.buildURLRequest(for: .login, with: data) else { return }
            print (urlRequest)
            self.triggerAPI(with: urlRequest, apiResponse: completion)
        }
        if (APIfor == .register && (data as? RegistrationRequiredInfo != nil)) {
            guard let urlRequest = self.buildURLRequest(for: .register, with: data) else { return }
            print (urlRequest)
            self.triggerAPI(with: urlRequest, apiResponse: completion)
        }
        
        if (APIfor == .uploadImage && (data as? UploadImageRequiredInfo != nil)) {
            guard let urlRequest = self.buildURLRequest(for: .uploadImage, with: data) else { return }
            print (urlRequest)
            self.triggerAPI(with: urlRequest, apiResponse: completion)
        }
        
        if (APIfor == .updateBio && (data as? UpdateBioRequiredInfo != nil)) {
            guard let urlRequest = self.buildURLRequest(for: .updateBio, with: data) else { return }
            print (urlRequest)
            self.triggerAPI(with: urlRequest, apiResponse: completion)
        }
    }
    
    func triggerAPI(with request: URLRequest, apiResponse success: @escaping Response) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    if let error = error {
                        success([],error)
                    } else {
                        success("[]",nil)
                    }
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                success(jsonResponse, nil)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
 }
    
    func buildURLRequest(for API: TriggerAPIFor, with data: Any)->URLRequest? {
        
        guard let localhostAddress = localhost else { return nil }
        
        switch API {
        case .login:
            guard let requestData  = data as? LoginRequiredInfo else { return nil }
            let urlString = "http://\(localhostAddress)/fb/login.php"
            let url = URL(string:urlString)!
            let body = "email=\(requestData.userName)&password=\(requestData.password)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = MethodType.POST.rawValue
            return request
            
        case .register:
            guard let requestData  = data as? RegistrationRequiredInfo else { return nil }
            let urlString = "http://\(localhostAddress)/fb/register.php"
            let url = URL(string:urlString)!
            let body = "email=\(requestData.email)&firstName=\(requestData.firstName.trimmingCharacters(in: .whitespaces))&lastName=\(requestData.lastName.trimmingCharacters(in: .whitespaces))&password=\(requestData.password)&birthday=\(requestData.birthDay.trimmingCharacters(in: .whitespaces))&gender=\(requestData.gender)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = MethodType.POST.rawValue
            
            return request
            
        case .uploadImage:
            guard let requestData  = data as? UploadImageRequiredInfo else { return nil }
            
            let url = URL(string: "http://\(localhostAddress)/fb/uploadImage.php")!
            var request = URLRequest(url: url)
            
            // POST - safest method of passing data to the server
            request.httpMethod = MethodType.POST.rawValue
            
            // values to be sent to the server under keys (e.g. ID, TYPE)
            let params = ["id": CustomerProfile.shared.userID, "type": requestData.imgType.rawValue]
            
            // MIME Boundary, Header
            let boundary = "Boundary-\(NSUUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // assigning full body to the request to be sent to the server
            request.httpBody = Helper().body(with: params, filename: "\(requestData.imgType.rawValue).jpg", filePathKey: "file", imageDataKey: requestData.imgData, boundary: boundary) as Data
            
            return request
            
        case .updateBio:
            guard let requestData = data as? UpdateBioRequiredInfo else { return nil }
            let urlString = "http://\(localhostAddress)/fb/updateBio.php"
            let url = URL(string:urlString)!
            let body = "id=\(CustomerProfile.shared.userID)&bio=\(requestData.bioData)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = MethodType.POST.rawValue
            
            return request
        }
    }
}

