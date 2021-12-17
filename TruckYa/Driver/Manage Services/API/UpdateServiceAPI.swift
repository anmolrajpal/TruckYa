//
//  UpdateServiceAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
final class UpdateServiceAPI: NSObject, UpdateServiceAPIProtocol {
    static let shared = UpdateServiceAPI()
    var dataTask = URLSessionDataTask()
    func update(userId: String, stopAndDropPrice: String, oneDriverHelpsUploadPrice: String, twoDriversHelpUploadPrice: String, trailerHitchMovesPrice: String, dirtyJobsPrice: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "stopanddrop":stopAndDropPrice,
            "onedriverhelpsupload": oneDriverHelpsUploadPrice,
            "twodriverhelpsupload": twoDriversHelpUploadPrice,
            "trailerhitchmove": trailerHitchMovesPrice,
            "hultingtodumpsdirtyjob": dirtyJobsPrice
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateServicePrice) else {
            print("Error Log: Unable to Construct URL")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
            return
        }
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
    
    func fetch(driverId: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":driverId,
            "driverid":driverId
        ]
        guard let url = URLSession.shared.constructURL(path: .GetServicePrice) else {
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
        
        
        dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                self.handleResponse(data: data, error: error, completion: completion)
            }
        })
        dataTask.resume()
    }
}
