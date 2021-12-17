//
//  LocationAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation
final class LocationAPI: NSObject, LocationAPIProtocol {
    static let shared = LocationAPI()
    func updateCurrentLocation(userId: String, coordinates:CLLocationCoordinate2D, completion: @escaping APICompletion) {
        let parameters:[String:Any] = [
            "userid":userId,
            "lat":coordinates.latitude,
            "long":coordinates.longitude
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateCurrentLocation) else {
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
    
    func getDriverLocation(userId:String, bookingId:String, completion: @escaping APICompletion) {
        let parameters:[String:Any] = [
            "userid":userId,
            "bookingid":bookingId
        ]
        guard let url = URLSession.shared.constructURL(path: .GetDriverLocation) else {
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
