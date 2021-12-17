//
//  HTTPClient.swift
//  Pedicab
//
//  Created by Anshul on 02/07/19.
//  Copyright © 2019 com.seg. All rights reserved.
//

import Alamofire

class HTTPClient {
    
    var headers = ["content-type": "application/json", "accept": "application/json"]
    
    func get(urlString: String, params: [String: Any]?, token: String?, callback:@escaping (_ data: Data?, _ error: Error?) -> Void){
        if let url = URL(string: urlString){
            if(token != nil){
                headers["Authorization"] = "Bearer \(token!)"
            }
            Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result{
                    case .success(_):
                        callback(response.data, nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                        callback(nil, error)
                    }
            }
        }
    }
    
    func post(urlString: String, params: [String: Any], token: String?, callback:@escaping (_ data: Data?, _ error: Error?) -> Void){
        if let url = URL(string: urlString){
            if(token != nil){
                headers["Authorization"] = "Bearer \(token!)"
            }
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result{
                    case .success(_):
                        callback(response.data, nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                        callback(nil, error)
                    }
            }
        }
    }
    
    func upload(urlString: String , params: [String : Any], token: String?, userImage: UIImage, imageName: String,  callback :@escaping ( _ response : Data?, _ error : Error?) -> Void) {
        var multipartHeader = ["content-type": "multipart/form-data", "accept": "application/json"]
        if(token != nil){
            multipartHeader["Authorization"] = "Bearer \(token!)"
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let imageData = userImage.jpegData(compressionQuality: 0.4){
                multipartFormData.append(imageData, withName: imageName, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: multipartHeader) { (Result) in
            switch Result{
            case .success(let request, _,  _):
                request.responseJSON(completionHandler: { (response) in
                    callback(response.data, nil)
                })
                request.uploadProgress { progress in
                    //let uploadProgress = progress.fractionCompleted * 100
                    //ProgressHUD.show(String(format: "%.0f", uploadProgress) + "%")
                    print(progress.fractionCompleted)
                }
            case .failure(let error):
                callback(nil,error)
                //print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
}

struct Endpoint {
    
    static let baseUrl = "http://3.130.157.207:3032/api"
    static let baseUrlImage = "http://3.130.157.207:3032/"
    static let termsAndCondition = ""
    static let privacyPolicy = ""
    
    static let getAllCards = baseUrl + "/stripe/getallcards"
    static let saveCard = baseUrl + "/stripe/savecustomercard"
    static let payNow = baseUrl + "/bookings/paynow"
}
