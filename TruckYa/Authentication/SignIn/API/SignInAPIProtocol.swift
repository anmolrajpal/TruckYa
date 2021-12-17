//
//  SignInAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 01/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol SignInAPIProtocol: NSObject, APIProtocol {
    func signIn(email:String, password:String, completion: @escaping APICompletion)
}
