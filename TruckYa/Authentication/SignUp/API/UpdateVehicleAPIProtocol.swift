//
//  UpdateVehicleAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateVehicleAPIProtocol: NSObject, APIProtocol {
    func updateVehicleInfo(imageURL:String, imageData:Data, userId:String, vehiclePlateNo:String, vehicleType:String, vehicleColor:String, completion: @escaping APICompletion)
}
