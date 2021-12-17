//
//  ChangePasswordVCDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
extension ChangePasswordVC {
    internal func callChangePasswordSequence(userID:String, password:String) {
        ChangePasswordAPI.shared.changePassword(for: userID, with: password) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                self.fallBackToIdentity()
                let alertview = JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: error.localizedDescription,
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                alertview.setTextTheme(.light)
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                self.fallBackToIdentity()
                let customIcon = UIImage(named: "oho")
                let alertview = JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: serviceError.localizedDescription,
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1),
                                                    iconImage: customIcon)
                alertview.setTextTheme(.light)
            } else if let data = data {
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
                    guard let status = result["status"] as? String else {
                        print("MARK: Unable to get Result Status from API Call")
                        self.fallBackToIdentity()
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: "Service Error. Please try again in a while",
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1),
                                                            iconImage: UIImage(named: "oho"))
                        alertview.setTextTheme(.light)
                        alertview.addAction({
                            //                            self.fallBackToIdentity()
                        })
                        return
                    }
                    let message = result["message"] as? String
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        self.fallBackToIdentity()
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: message ?? "Unable to verify email. Please try again",
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1),
                                                            iconImage: UIImage(named: "oho"))
                        alertview.setTextTheme(.light)
                        alertview.addAction({
                            //                            self.fallBackToIdentity()
                        })
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "FP Success")")
                        self.fallBackToIdentity(with: .Success)
                        self.handleSuccess()
                    case .none: print("Unknown Case")
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: "Service Internal Error. Please contact support",
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1),
                                                        iconImage: UIImage(named: "oho"))
                    alertview.setTextTheme(.light)
                    alertview.addAction({
                        self.fallBackToIdentity()
                    })
                    fatalError()
                    }
                    
                } catch let err {
                    print("Unable to decode data")
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: err.localizedDescription,
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1),
                                                        iconImage: UIImage(named: "oho"))
                    alertview.setTextTheme(.light)
                }
            }
        }
    }
}
