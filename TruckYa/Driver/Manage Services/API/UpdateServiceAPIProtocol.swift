//
//  UpdateServiceAPIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol UpdateServiceAPIProtocol: NSObject, APIProtocol {
    var dataTask: URLSessionDataTask { get set }
    func update(userId:String, stopAndDropPrice:String, oneDriverHelpsUploadPrice:String, twoDriversHelpUploadPrice:String, trailerHitchMovesPrice:String, dirtyJobsPrice:String, completion: @escaping APICompletion)
    func fetch(driverId:String, completion: @escaping APICompletion)
}
