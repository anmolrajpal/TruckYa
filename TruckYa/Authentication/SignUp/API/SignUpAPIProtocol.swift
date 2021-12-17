//
//  SignUpAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 14/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol SignUpAPIProtocol: NSObject, APIProtocol {
    func signUp(name:String, email:String, password:String, phoneNumber:String, userType:UserType, completion: @escaping APICompletion)
}
