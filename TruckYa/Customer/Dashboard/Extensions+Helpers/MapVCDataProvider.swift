//
//  MapVCDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 28/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import CoreLocation
extension MapViewController  {
    internal func callGetDriverLocationSequence(userId: String, bookingId: String) {
            LocationAPI.shared.getDriverLocation(userId: userId, bookingId: bookingId) { (data, serviceError, error) in
                if let error = error {
                    print("Oh no Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
//                        self.fallBackToIdentity(with: .Error)
//                        let alertview = JSSAlertView().show(self,
//                                                            title: "Error",
//                                                            text: error.localizedDescription,
//                                                            buttonText: "OK",
//                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
//                        alertview.setTextTheme(.light)
                    }
                } else if let serviceError = serviceError {
                    print("Oh No Service Error: \(serviceError.localizedDescription)")
//                    DispatchQueue.main.async {
//                        self.fallBackToIdentity(with: .Error)
//                        let alertview = JSSAlertView().show(self,
//                                                            title: "Error",
//                                                            text: serviceError.localizedDescription,
//                                                            buttonText: "OK",
//                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
//                        alertview.setTextTheme(.light)
//                    }
                } else if let data = data {
                    
                    guard let _:String = String(data: data, encoding: .utf8) else {
                        print("Unable to convert Data to JSON String")
                        return
                    }
//                    print("\n\n••• ---------------------------------------------- •••\n\n"+jsonString+"\n\n••• ---------------------------------------------- •••\n\n")
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
//                        print(result as Any)
                        if let data = result?["data"] as? [[String:AnyObject]] {
                            if let object = data.first {
                                if let latitude = object["lat"] as? Double,
                                    let longitude = object["long"] as? Double {
                                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    self.didReceiveDriverLocation(coordinates: coordinates)
                                }
                            }
                            
                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    
                    /*
                    let decoder = JSONDecoder()
                    do {
                        let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                        print(res as Any)
                        
                        let result = try decoder.decode(NearbyDriversCodable.self, from: data)
                        print(result)
                        guard let status = result.status else {
                            print("MARK: Unable to get Result Status from API Call")
                            DispatchQueue.main.async {
//                                self.fallBackToIdentity(with: .Error)
//                                let alertview = JSSAlertView().show(self,
//                                                                    title: "Error",
//                                                                    text: "Service Error. Please try again in a while",
//                                                                    buttonText: "OK",
//                                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
//                                alertview.setTextTheme(.light)
                            }
                            return
                        }
                        let message = result.message
                        let resultStatus = APIResultStatus(rawValue: status)
                        switch resultStatus {
                        case .Error:
                            print("Error: \(message ?? "Description: nil")")
                            DispatchQueue.main.async {
//                                self.fallBackToIdentity(with: .Error)
//                                let alertview = JSSAlertView().show(self,
//                                                                    title: "Error",
//                                                                    text: message ?? "Unable to verify email. Please try again",
//                                                                    buttonText: "OK",
//                                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
//                                alertview.setTextTheme(.light)
                            }
                            
                        case .Success:
                            print("Success")
                            print("\(message ?? "Nearby Drivers Success")")
                            
                            let jsonString = String(data: data, encoding: .utf8)!
                            print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                            
                            if let userData = result.data,
                                !userData.isEmpty,
                                let nearbyDrivers = userData.first?.drivers {
    //                            self.fallBackToIdentity(with: .Success)
                                
                            } else {
                                print("API Internal Error: Rider MetaData & Details are nil")
                                DispatchQueue.main.async {
//                                    self.fallBackToIdentity(with: .Error)
//                                    let alertview = JSSAlertView().show(self,
//                                                                        title: "Error",
//                                                                        text: message ?? "Service Error. Please try again in a while",
//                                                                        buttonText: "OK",
//                                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
//                                    alertview.setTextTheme(.light)
                                }
                            }
                            
                        case .none: print("Unknown Case")
                        DispatchQueue.main.async {
//                            self.fallBackToIdentity(with: .Error)
//                            let alertview = JSSAlertView().show(self,
//                                                                title: "Error",
//                                                                text: "Service Internal Error. Please contact support",
//                                                                buttonText: "OK",
//                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
//                            alertview.setTextTheme(.light)
                            }
                        }
                    } catch let err {
                        print("Unable to decode data")
                        DispatchQueue.main.async {
//                            self.fallBackToIdentity(with: .Error)
//                            let alertview = JSSAlertView().show(self,
//                                                                title: "Error",
//                                                                text: err.localizedDescription,
//                                                                buttonText: "OK",
//                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
//                            alertview.setTextTheme(.light)
                        }
                    }
                    
                    */
                    
                }
            }
        }
}
