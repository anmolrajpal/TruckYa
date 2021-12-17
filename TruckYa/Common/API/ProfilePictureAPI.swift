//
//  ProfilePictureAPI.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation

protocol ProfilePictureUploadTaskDelegate {
    func getUploadProgress(progress:Progress)
}
final class ProfilePictureAPI: NSObject, ProfilePictureAPIProtocol, URLSessionTaskDelegate {
    static let shared =  ProfilePictureAPI()
    var delegate:ProfilePictureUploadTaskDelegate?
    var uploadTask = URLSessionUploadTask()
    var uploadProgress:Progress = Progress(totalUnitCount: 0)
    
    func upload(userId: String, imageData: Data, imageName: String, completion: @escaping APICompletion) {
        let parameters:[String:String] = [
            "userid":userId
        ]
        guard let url = URLSession.shared.constructURL(path: .UpdateProfilePicture) else {
            print("Error Log: Unable to Construct URL")
            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
            return
        }
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.EndpointConfig.timeOutInterval)
        request.httpMethod = HTTPMethod.POST.rawValue
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        } catch let err {
//            print("Error Encoding JSON: \(err.localizedDescription)")
//            completion(nil, .Internal, NSError(domain: "", code: ResponseStatus.getStatusCode(by: .BadRequest), userInfo: nil))
//        }
        
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
//        request.addValue(Header.contentType.multipart.rawValue, forHTTPHeaderField: Header.headerName.contentType.rawValue)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        for(key, value) in parameters {
            // Add the reqtype field and its value to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)".data(using: .utf8)!)
        }
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"profilepic\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        
        
        
        // Send a POST request to the URL, with the data we created earlier
        uploadTask = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main).uploadTask(with: request, from: data, completionHandler: { data, response, error in
            self.handleResponse(data: data, error: error, completion: completion)
        })
        uploadTask.resume()

        
        
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            DispatchQueue.main.async {
//                self.handleResponse(data: data, error: error, completion: completion)
//            }
//        }.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
//        self.delegate?.getUploadProgress(progress: uploadProgress)
        uploadProgress.totalUnitCount = totalBytesExpectedToSend
        uploadProgress.completedUnitCount = totalBytesSent
        delegate?.getUploadProgress(progress: uploadProgress)
    }
}
