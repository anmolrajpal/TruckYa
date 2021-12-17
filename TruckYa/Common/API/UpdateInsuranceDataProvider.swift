//
//  UpdateInsuranceDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView

extension DriverSignupVCForm5 {
    internal func callUpdateInsuranceInfoSequence(imageURL:String, imageData:Data, userId:String, insuranceNumber:String, companyName:String, insuranceAmount:String, issueDate:String, voidDate:String) {
        UpdateInsuranceAPI.shared.updateInsuranceInfo(imageURL: imageURL, imageData: imageData, userId: userId, insuranceNumber:insuranceNumber, companyName:companyName, insuranceAmount:insuranceAmount, issueDate:issueDate, voidDate:voidDate) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.fallBackToIdentity()
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
                    self.fallBackToIdentity()
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
                    let result = try decoder.decode(UserResponseCodable.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            self.fallBackToIdentity()
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
                            self.fallBackToIdentity()
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Unable to verify email. Please try again",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                        }
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "Upload Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let userDetails = userData.first?.user {
                            self.handleUserState(with: userDetails)
                            self.fallBackToIdentity(with: .Success)
                            self.handleSuccess()
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            DispatchQueue.main.async {
                                self.fallBackToIdentity()
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
                        self.fallBackToIdentity()
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
                        self.fallBackToIdentity()
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
}

