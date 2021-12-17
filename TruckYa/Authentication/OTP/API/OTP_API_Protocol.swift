//
//  OTP-API-Protocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol OTP_API_Protocol: NSObject, APIProtocol {
    func verifyOTP(for email:String, with otp:String, completion: @escaping APICompletion)
}
