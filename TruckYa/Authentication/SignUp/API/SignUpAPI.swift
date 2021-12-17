//
//  SignUpAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 14/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
final class SignUpAPI: NSObject, SignUpAPIProtocol {
    static let shared =  SignUpAPI()
    
    func signUp(name:String, email: String, password: String, phoneNumber:String, userType:UserType, completion: @escaping APICompletion) {
        print("SignUp API userType => \(userType.rawValue)")
        let parameters:[String:String] = [
            "fullname":name,
            "email":email,
            "password":password,
            "mobileno":phoneNumber,
            "usertype":userType.rawValue
        ]
        guard let url = URLSession.shared.constructURL(path: .SignUp) else {
            print("Error Log: Unable to Construct URL")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
            return
        }
        print(url)
        print(parameters)
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.EndpointConfig.timeOutInterval)
        request.httpMethod = HTTPMethod.POST.rawValue
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let err {
            print("Error Encoding JSON: \(err.localizedDescription)")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
        }
        request.addValue(Header.contentType.json.rawValue, forHTTPHeaderField: Header.headerName.contentType.rawValue)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                self.handleResponse(data: data, error: error, completion: completion)
            }
        }.resume()
    }
}
