//
//  ProfilePictureAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol ProfilePictureAPIProtocol: NSObject, APIProtocol {
    var uploadTask:URLSessionUploadTask { get set }
    var uploadProgress:Progress { get }
    func upload(userId: String, imageData: Data, imageName: String, completion: @escaping APICompletion)
}
