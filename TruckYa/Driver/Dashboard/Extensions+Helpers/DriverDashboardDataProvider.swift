//
//  DriverDashboardDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 27/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView

extension DriverDashboardVC {
    internal func acceptBooking(userId:String, bookingId:String) {
        ManageBookingAPI.shared.acceptBooking(userId: userId, bookingId: bookingId) { (data, serviceError, error) in
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
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let result = try decoder.decode(AcceptBookingResponseCodable.self, from: data)
                    print(result)
                    //                    self.signInResult = result
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
                                                    text: message ?? "Unable to verify email. Please try again",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1)).setTextTheme(.light)
                            }
                        }
                        
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "Upload Success")")
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        
                        if let datum = result.data,
                            !datum.isEmpty,
                            let details = datum.first?.booking {
                            self.bookingDetails = details
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
                                                        text: "Service Error. Please try again",
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
    
    
    
    
    
    
    internal func declineBooking(userId:String, bookingId:String) {
        ManageBookingAPI.shared.declineBooking(userId: userId, bookingId: bookingId) { (data, serviceError, error) in
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
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    guard let status = result["status"] as? String else {
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
                    let message = result["message"] as? String
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
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                self.handleDeclineSuccess()
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
    
    
    
    
    
    
    
    
    
    
    internal func driverReachedToSource(userId:String, bookingId:String) {
        ManageBookingAPI.shared.driverReachedToSource(userId: userId, bookingId: bookingId) { (data, serviceError, error) in
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
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    guard let status = result["status"] as? String else {
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
                    let message = result["message"] as? String
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
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                self.handleDriverReachedSuccess()
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
    
    internal func startJourney(userId:String, bookingId:String, bookingCode:String) {
        ManageBookingAPI.shared.startTrip(userId: userId, bookingId: bookingId, bookingCode: bookingCode) { (data, serviceError, error) in
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
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    guard let status = result["status"] as? String else {
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
                    let message = result["message"] as? String
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
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                self.handleDriverStartJourneySuccess()
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
    
    
    internal func stopJourney(userId:String, bookingId:String) {
        ManageBookingAPI.shared.stopTrip(userId: userId, bookingId: bookingId) { (data, serviceError, error) in
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
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    guard let status = result["status"] as? String else {
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
                    let message = result["message"] as? String
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
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                self.handleDriverReachedDestinationSuccess()
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
