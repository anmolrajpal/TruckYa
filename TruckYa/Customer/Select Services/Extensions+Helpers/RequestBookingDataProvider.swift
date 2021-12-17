//
//  RequestBookingDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 26/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import CoreLocation
extension CustomerMapVC {
    internal func callRequestBoookingSequence(userId: String, driverId: String, sourceAddress: String, sourceCoordinates: CLLocationCoordinate2D, destinationAddress: String, destinationCoordinates: CLLocationCoordinate2D, stopAndDropServiceCheck: Bool, oneDriverServiceCheck: Bool, twoDriversServiceCheck: Bool, trailerHitchServiceCheck: Bool, dirtyJobsServiceCheck: Bool, customerNotes:String) {
        print(userId)
        BookingsAPI.shared.requestBooking(userId: userId, driverId: driverId, sourceAddress: sourceAddress, sourceCoordinates: sourceCoordinates, destinationAddress: destinationAddress, destinationCoordinates: destinationCoordinates, stopAndDropServiceCheck: stopAndDropServiceCheck, oneDriverServiceCheck: oneDriverServiceCheck, twoDriversServiceCheck: twoDriversServiceCheck, trailerHitchServiceCheck: trailerHitchServiceCheck, dirtyJobsServiceCheck: dirtyJobsServiceCheck, customerNotes: customerNotes) { (data, serviceError, error) in
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
                
                let decoder = JSONDecoder()
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    print(res as Any)
                    let result = try decoder.decode(BookingRequestResponseCodable.self, from: data)
                    print(result)
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity()
                                JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: "Service Error. Please try again in a while",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                            }
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
                                                    text: message ?? "Unknown Error",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                            }
                        }
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "Nearby Drivers Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let bookingDetails = userData.first?.booking {
                            print(bookingDetails)
                            self.requestResponse = bookingDetails
                            DispatchQueue.main.async {
                                UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                    self.fallBackToIdentity(with: .Success)
                                    self.handleSuccess()
                                }
                            }
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            DispatchQueue.main.async {
                                UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                    self.fallBackToIdentity()
                                    JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: "Service Error. Please try again in a while",
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                                }
                            }
                        }
                        
                    case .none: print("Unknown Case")
                    DispatchQueue.main.async {
                        UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                            self.fallBackToIdentity()
                            JSSAlertView().show(self,
                                                title: "Error",
                                                text: "Service Internal Error. Please contact support",
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                        }
                        }
                    }
                } catch let err {
                    print("Unable to decode data")
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
