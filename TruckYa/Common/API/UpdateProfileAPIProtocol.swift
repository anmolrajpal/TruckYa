//
//  UpdateProfileAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateProfileAPIProtocol: NSObject, APIProtocol {
    func update(userId: String, fullName:String, mobileNo:String, city:String, address:String, state:String, country:String, postalCode:String, about:String, completion: @escaping APICompletion)
}
