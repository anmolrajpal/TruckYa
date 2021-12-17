//
//  UpdateVehicleAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateVehicleAPIDelegate {
    func getUploadProgress(progress:Float)
}
final class UpdateVehicleAPI: NSObject, UpdateVehicleAPIProtocol, URLSessionTaskDelegate {
    static let shared = UpdateVehicleAPI()
    var delegate:UpdateVehicleAPIDelegate?
    func updateVehicleInfo(imageURL: String, imageData: Data, userId: String, vehiclePlateNo: String, vehicleType: String, vehicleColor: String, completion: @escaping APICompletion) {
        
        let parameters:[String:String] = [
            "userid":userId,
            "vehicleplateno":vehiclePlateNo,
            "vehicletype":vehicleType,
            "vehiclecolor":vehicleColor
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateVehicleInfo) else {
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
        data.append("Content-Disposition: form-data; name=\"vehicleimage\"; filename=\"\(imageURL)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main).uploadTask(with: request, from: data, completionHandler: { data, response, error in
            self.handleResponse(data: data, error: error, completion: completion)
            
            
        }).resume()
        
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        self.delegate?.getUploadProgress(progress: uploadProgress)
    }
}
