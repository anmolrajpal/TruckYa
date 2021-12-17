//
//  ServiceAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 22/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol ServiceAPIProtocol: NSObject, APIProtocol {
    func fetchServiceData(userId:String, driverId:String, completion: @escaping APICompletion)
}
