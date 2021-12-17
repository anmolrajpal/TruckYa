//
//  CustomerDashboardDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import CoreLocation
extension CustomerDashboardVC {
    internal func callFetchNearbyDriversSequence(userId: String, coordinates: CLLocationCoordinate2D) {
        print(userId)
        print(coordinates)
        DriversAPI.shared.fetchNearbyDrivers(userId: userId, coordinates: coordinates) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.fallBackToIdentity(with: .Error)
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: error.localizedDescription,
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                    alertview.setTextTheme(.light)
                }
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                DispatchQueue.main.async {
                    self.fallBackToIdentity(with: .Error)
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: serviceError.localizedDescription,
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                    alertview.setTextTheme(.light)
                }
            } else if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    print(res as Any)
                    let result = try decoder.decode(NearbyDriversCodable.self, from: data)
                    print(result)
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            self.fallBackToIdentity(with: .Error)
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                        }
                        return
                    }
                    let message = result.message
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        DispatchQueue.main.async {
                            self.fallBackToIdentity(with: .Error)
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Unable to verify email. Please try again",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
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
                            self.nearbyDrivers = nearbyDrivers
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            DispatchQueue.main.async {
                                self.fallBackToIdentity(with: .Error)
                                let alertview = JSSAlertView().show(self,
                                                                    title: "Error",
                                                                    text: message ?? "Service Error. Please try again in a while",
                                                                    buttonText: "OK",
                                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                                alertview.setTextTheme(.light)
                            }
                        }
                        
                    case .none: print("Unknown Case")
                    DispatchQueue.main.async {
                        self.fallBackToIdentity(with: .Error)
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: "Service Internal Error. Please contact support",
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertview.setTextTheme(.light)
                        }
                    }
                } catch let err {
                    print("Unable to decode data")
                    DispatchQueue.main.async {
                        self.fallBackToIdentity(with: .Error)
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: err.localizedDescription,
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertview.setTextTheme(.light)
                    }
                }
            }
        }
    }
    func callGetCurrentBookingsSequence(userId:String) {
        BookingsAPI.shared.getCurrentBookings(userId: userId) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                        self.fallBackToIdentity()
                        JSSAlertView().show(self,
                                            title: "Error",
                                            text: error.localizedDescription,
                                            buttonText: "OK",
                                            color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                    }
                    
                }
                
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                DispatchQueue.main.async {
                    UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                        self.fallBackToIdentity()
                        JSSAlertView().show(self,
                                            title: "Error",
                                            text: serviceError.localizedDescription,
                                            buttonText: "OK",
                                            color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                    }
                }
                
            } else if let data = data {
                
                let jsonString = String(data: data, encoding: .utf8)!
                print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CurrentBookings.self, from: data)
                    print(result)
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            self.fallBackToIdentity(with: .Error)
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                        }
                        return
                    }
                    let message = result.message
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity()
                                JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: message ?? "Unable to verify email. Please try again",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                            }
                        }
                        
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "Success")")
                        
                        guard let lastBooking = result.data?.first?.bookings?.last else {
                            print("No Last booking")
                            return
                        }
                        self.lastBookingDetails = lastBooking
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                
                            }
                        }
                        
                    case .none: print("Unknown Case")
                    DispatchQueue.main.async {
                        UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                            self.fallBackToIdentity()
                            JSSAlertView().show(self,
                                                title: "Error",
                                                text: "Service Internal Error. Please contact support" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                        }
                        }
                    }
                } catch let err {
                    print("Unable to decode data")
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                            self.fallBackToIdentity()
                            JSSAlertView().show(self,
                                                title: "Error",
                                                text: err.localizedDescription,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                        }
                    }
                }
            }
        }
    }
}


