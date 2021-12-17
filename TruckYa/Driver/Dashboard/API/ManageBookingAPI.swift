//
//  ManageBookingAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 27/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
final class ManageBookingAPI: NSObject, ManageBookingAPIProtocol {
    static let shared = ManageBookingAPI()

    func acceptBooking(userId:String, bookingId: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "bookingid":bookingId
        ]
        guard let url = URLSession.shared.constructURL(path: .AcceptBooking) else {
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
    
    
    
    func declineBooking(userId:String, bookingId: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "bookingid":bookingId
        ]
        guard let url = URLSession.shared.constructURL(path: .DeclineBooking) else {
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
    
    
    
    
    func driverReachedToSource(userId:String, bookingId: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "bookingid":bookingId
        ]
        guard let url = URLSession.shared.constructURL(path: .DriverReachedToSource) else {
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
    
    
    func startTrip(userId:String, bookingId: String, bookingCode:String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "bookingid":bookingId,
            "bookingcode":bookingCode
        ]
        guard let url = URLSession.shared.constructURL(path: .StartTrip) else {
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
    
    
    
    func stopTrip(userId:String, bookingId: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId,
            "bookingid":bookingId
        ]
        guard let url = URLSession.shared.constructURL(path: .StopTrip) else {
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
