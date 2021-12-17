//
//  APIProtocol.swift
//  TruckYa
//
//  Created by Digit Bazar on 01/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
protocol APIProtocol {
    typealias APICompletion = (Data?, APIServiceError?, Error?) -> ()
    func handleResponse(data: Data?, error: Error?, completion: @escaping APICompletion)
}
extension APIProtocol {
    func handleResponse(data: Data?, error: Error?, completion: @escaping APICompletion) {
        if let error = error {
            print("App Internal Set Error => \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(nil, .apiError, error)
            }
        } else if let data = data {
            completion(data, nil, nil)
        } else {
            DispatchQueue.main.async {
                completion(nil, .Unknown, nil)
            }
        }
    }
}
