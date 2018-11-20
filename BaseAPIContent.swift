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
        switch API {
        case .login:
            guard let requestData  = data as? LoginRequiredInfo else { return nil }
            let urlString = "http://\(localhost)/fb/login.php"
            let url = URL(string:urlString)!
            let body = "email=\(requestData.userName)&password=\(requestData.password)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = MethodType.POST.rawValue
            return request
            
        case .register:
            guard let requestData  = data as? RegistrationRequiredInfo else { return nil }
            let urlString = "http://\(localhost)/fb/register.php"
            let url = URL(string:urlString)!
            let body = "email=\(requestData.email)&firstName=\(requestData.firstName)&lastName=\(requestData.lastName)&password=\(requestData.password)&birthday=\(requestData.birthDay)&gender=\(requestData.gender)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = MethodType.POST.rawValue
            
            return request
        }
    }
}

