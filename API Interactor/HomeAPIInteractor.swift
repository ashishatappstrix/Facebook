//
//  HomeAPIInteractor.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/25/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import Foundation

class HomeAPIInteractor {
    typealias ImageUploadedCompletionHandler = (ImageUploadedResponse) -> ()
    typealias BioUploadedCompletionHandler = (BioUploadedResponse) -> ()
    
    func uploadImage(with info: UploadImageRequiredInfo, response: @escaping(ImageUploadedCompletionHandler)) {
        APIRequestHandler().trigger(APIfor: .uploadImage, data: info) { (receivedResponse, error) in
            
            if error == nil {
                if let apiResponse = receivedResponse as? Dictionary<String, Any> {
                    let reqData = ImageUploadedResponse(data: apiResponse)
                    response(reqData)
                }
            }
        }
    }
    
    func updateBioData(with info: UpdateBioRequiredInfo, response: @escaping(BioUploadedCompletionHandler)) {
        APIRequestHandler().trigger(APIfor: .updateBio, data: info) { (receivedResponse, error) in
            
            if error == nil {
                if let apiResponse = receivedResponse as? Dictionary<String, Any> {
                    let reqData = BioUploadedResponse(data: apiResponse)
                    response(reqData)
                }
            }
        }
    }
}
