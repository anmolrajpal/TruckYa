//
//  UpdateLicenseAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateLicenseAPIProtocol: NSObject, APIProtocol {
    func updateLicenseInfo(imageURL:String, imageData:Data, userId:String, licenseNumber:String, issueDate:String, voidDate:String, completion: @escaping APICompletion)
}
