//
//  ManageBookingAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 27/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol ManageBookingAPIProtocol: NSObject, APIProtocol {
    func acceptBooking(userId:String, bookingId:String, completion: @escaping APICompletion)
    func declineBooking(userId:String, bookingId:String, completion: @escaping APICompletion)
    func driverReachedToSource(userId:String, bookingId:String, completion: @escaping APICompletion)
    func startTrip(userId:String, bookingId:String, bookingCode:String, completion: @escaping APICompletion)
    func stopTrip(userId:String, bookingId:String, completion: @escaping APICompletion)
    
}
