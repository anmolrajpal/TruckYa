//
//  UpdateProfileAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
final class UpdateProfileAPI: NSObject, UpdateProfileAPIProtocol {
    static let shared = UpdateProfileAPI()
    func update(userId: String, fullName: String, mobileNo: String, city: String, address: String, state: String, country: String, postalCode: String, about: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "fullname":fullName,
            "mobileno": mobileNo,
            "city": city,
            "address": address,
            "state": state,
            "country": country,
            "zipcode": postalCode,
            "about":about
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateProfile) else {
            print("Error Log: Unable to Construct URL")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
            return
        }
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
