//
//  SelectServicesDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 22/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView

extension SelectServicesVC {
    
    
    
    internal func callFetchServicePricesSequence(userId:String, driverId:String) {
        ServiceAPI.shared.fetchServiceData(userId: userId, driverId: driverId) { (data, serviceError, error) in
                if let error = error {
                    print("Oh no Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
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
                        let result = try decoder.decode(ServicesCodable.self, from: data)
                        print(result)
                        //                    self.signInResult = result
                        guard let status = result.status else {
                            print("MARK: Unable to get Result Status from API Call")
                            DispatchQueue.main.async {
                                let alertview = JSSAlertView().show(self,
                                                                    title: "Error",
                                                                    text: "Service Error. Please try again in a while",
                                                                    buttonText: "OK",
                                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                                alertview.setTextTheme(.light)
                                alertview.addAction {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            return
                        }
                        let message = result.message
                        let resultStatus = APIResultStatus(rawValue: status)
                        switch resultStatus {
                        case .Error:
                            print("Error: \(message ?? "Description: nil")")
                            if message == "Price not set yet." {
                                DispatchQueue.main.async {
                                    let alertview = JSSAlertView().show(self,
                                                                        title: "Sorry",
                                                                        text: "This Driver's services are not available at the moment",
                                                                        buttonText: "OK",
                                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                                    alertview.setTextTheme(.light)
                                    alertview.addAction {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let alertview = JSSAlertView().show(self,
                                                                        title: "Error",
                                                                        text: message ?? "Unable to verify email. Please try again",
                                                                        buttonText: "OK",
                                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                                    alertview.setTextTheme(.light)
                                    alertview.addAction {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                            
                        case .Success:
                            print("Success")
                            print("\(message ?? "Upload Success")")
                            let jsonString = String(data: data, encoding: .utf8)!
                            print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                            if let userData = result.data,
                                !userData.isEmpty,
                                let userServices = userData.first?.userservices {
                                self.services = userServices
    //                            self.handleSuccess()
                            } else {
                                print("API Internal Error: Rider MetaData & Details are nil")
                                DispatchQueue.main.async {
                                    let alertview = JSSAlertView().show(self,
                                                                        title: "Error",
                                                                        text: message ?? "Service Error. Please try again in a while",
                                                                        buttonText: "OK",
                                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                                    alertview.setTextTheme(.light)
                                    alertview.addAction {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        case .none: print("Unknown Case")
                        DispatchQueue.main.async {
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: "Service Internal Error. Please contact support",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                            alertview.addAction {
                                self.navigationController?.popViewController(animated: true)
                            }
                            }
                        }
                    } catch let err {
                        print("Unable to decode data")
                        DispatchQueue.main.async {
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: err.localizedDescription,
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                            alertview.addAction {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
}
