//
//  UpdateInsuranceAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateInsuranceAPIProtocol: NSObject, APIProtocol {
    func updateInsuranceInfo(imageURL:String, imageData:Data, userId:String, insuranceNumber:String, companyName:String, insuranceAmount:String, issueDate:String, voidDate:String, completion: @escaping APICompletion)
}
