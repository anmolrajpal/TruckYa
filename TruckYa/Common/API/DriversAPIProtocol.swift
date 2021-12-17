//
//  DriversAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation
protocol DriversAPIProtocol: NSObject, APIProtocol {
    func fetchNearbyDrivers(userId: String, coordinates:CLLocationCoordinate2D, completion: @escaping APICompletion)
}
