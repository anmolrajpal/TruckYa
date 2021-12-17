//
//  BookingsAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation
protocol BookingsAPIProtocol: NSObject, APIProtocol {
    func requestBooking(userId: String, driverId:String, sourceAddress:String, sourceCoordinates:CLLocationCoordinate2D, destinationAddress:String, destinationCoordinates:CLLocationCoordinate2D, stopAndDropServiceCheck:Bool, oneDriverServiceCheck:Bool, twoDriversServiceCheck:Bool, trailerHitchServiceCheck:Bool, dirtyJobsServiceCheck:Bool, customerNotes:String, completion: @escaping APICompletion)
    func getCurrentBookings(userId: String, completion: @escaping APICompletion)
}
