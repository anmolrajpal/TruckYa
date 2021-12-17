//
//  LocationAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationAPIProtocol: NSObject, APIProtocol {
    func updateCurrentLocation(userId: String, coordinates:CLLocationCoordinate2D, completion: @escaping APICompletion)
    func getDriverLocation(userId:String, bookingId:String, completion: @escaping APICompletion)
}
