//
//  AccountsAPIInteractor.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/19/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation

class AccountsAPIInteractor {
    
    typealias LoginInfo = LoginRequiredInfo
    typealias LoginCompletionHandler = (LoginResponse) -> ()
    
    func getLoginStatus(with info: LoginRequiredInfo, response: @escaping(LoginCompletionHandler)) {
        APIRequestHandler().trigger(APIfor: .login, data: info) { (receivedResponse, error) in
            if error == nil {
                if let apiResponse = receivedResponse as? Dictionary<String, Any> {
                    let reqData = LoginResponse(data: apiResponse)
                    response(reqData)
                }
            print(response)
        }
    }
  }
}
