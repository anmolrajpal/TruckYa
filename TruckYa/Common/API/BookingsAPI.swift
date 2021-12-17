//
//  BookingsAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation
final class BookingsAPI: NSObject, BookingsAPIProtocol {
    static let shared = BookingsAPI()
    var dataTask = URLSessionDataTask()
    func requestBooking(userId: String, driverId: String, sourceAddress: String, sourceCoordinates: CLLocationCoordinate2D, destinationAddress: String, destinationCoordinates: CLLocationCoordinate2D, stopAndDropServiceCheck: Bool, oneDriverServiceCheck: Bool, twoDriversServiceCheck: Bool, trailerHitchServiceCheck: Bool, dirtyJobsServiceCheck: Bool, customerNotes:String, completion: @escaping APICompletion) {
        let parameters:[String:Any] = [
            "userid":userId,
            "driverid":driverId,
            "source":sourceAddress,
            "destination":destinationAddress,
            "destlat": destinationCoordinates.latitude,
            "destlong": destinationCoordinates.longitude,
            "sourcelat": sourceCoordinates.latitude,
            "sourcelong": sourceCoordinates.longitude,
            "stopanddrop": stopAndDropServiceCheck.toString(),
            "onedriverhelpsupload": oneDriverServiceCheck.toString(),
            "twodriverhelpsupload": twoDriversServiceCheck.toString(),
            "trailerhitchmove": trailerHitchServiceCheck.toString(),
            "hultingtodumpsdirtyjob": dirtyJobsServiceCheck.toString(),
            "comments": customerNotes
        ]
        
        guard let url = URLSession.shared.constructURL(path: .RequestBooking) else {
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
    func getCurrentBookings(userId: String, completion: @escaping APICompletion) {
        let parameters:[String:Any] = [
            "userid":userId
        ]
        guard let url = URLSession.shared.constructURL(path: .GetCurrentBookings) else {
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
        dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                self.handleResponse(data: data, error: error, completion: completion)
            }
        }
        dataTask.resume()
    }
    
    func getMyBookings(userId: String, completion: @escaping APICompletion) {
        let parameters:[String:Any] = [
            "userid":userId
        ]
        guard let url = URLSession.shared.constructURL(path: .GetMyBookings) else {
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
        dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                self.handleResponse(data: data, error: error, completion: completion)
            }
        }
        dataTask.resume()
    }
}
