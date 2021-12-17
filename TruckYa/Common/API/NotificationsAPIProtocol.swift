//
//  NotificationsAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol NotificationsAPIProtocol: NSObject, APIProtocol {
    func updateFCMToken(userId: String, token:String, completion: @escaping APICompletion)
}
