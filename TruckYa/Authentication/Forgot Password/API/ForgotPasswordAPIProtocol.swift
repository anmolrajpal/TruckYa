//
//  ForgotPasswordAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol ForgotPasswordAPIProtocol: NSObject, APIProtocol {
    func forgotPassword(for email:String, completion: @escaping APICompletion)
}
