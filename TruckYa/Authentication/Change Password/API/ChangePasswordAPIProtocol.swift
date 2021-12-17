//
//  ChangePasswordAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol ChangePasswordAPIProtocol: NSObject, APIProtocol {
    func changePassword(for userID:String, with password:String, completion: @escaping APICompletion)
}
