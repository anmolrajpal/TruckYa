//
//  UpdateLicesnseAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
final class UpdateLicenseAPI: NSObject, UpdateLicenseAPIProtocol, URLSessionTaskDelegate {
    static let shared = UpdateLicenseAPI()
    
    func updateLicenseInfo(imageURL: String, imageData: Data, userId: String, licenseNumber: String, issueDate: String, voidDate: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "licenseno":licenseNumber,
            "issuedate":issueDate,
            "tilldate":voidDate
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateLicenseInfo) else {
            print("Error Log: Unable to Construct URL")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
            return
        }
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.EndpointConfig.timeOutInterval)
        request.httpMethod = HTTPMethod.POST.rawValue
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        for(key, value) in parameters {
            // Add the reqtype field and its value to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)".data(using: .utf8)!)
        }
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"licenseimage\"; filename=\"\(imageURL)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main).uploadTask(with: request, from: data, completionHandler: { data, response, error in
            self.handleResponse(data: data, error: error, completion: completion)
        }).resume()
    }
}
