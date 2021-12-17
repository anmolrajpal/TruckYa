//
//  SetProfileDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
extension DriverSignupVCForm2 {
    internal func callUpdateProfilePictureSequence(imageURL: String, imageData:Data, userID:String) {
        ProfilePictureAPI.shared.upload(userId: userId, imageData: imageData, imageName: imageURL) { (data, serviceError, error) in
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
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SignInCodable.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
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
                    let message = result.message
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
                        print("\(message ?? "Upload Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let userDetails = userData.first?.user,
                            let imageURL = userDetails.profilepic,
                            !imageURL.isEmpty {
                            //                            self.handleUserState(with: userDetails)
                            self.profileImageURL = imageURL
                            self.fallBackToIdentity(with: .Success)
                            self.handleProfileUploadSuccess()
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                                iconImage: UIImage(named: "oho"))
                            alertview.setTextTheme(.light)
                            alertview.addAction({
                                self.fallBackToIdentity()
                            })
                        }
                        
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
    
    
    
    
    internal func callUpdateProfileSequence(userId: String, fullName:String, mobileNo:String, city:String, address:String, state:String, country:String, postalCode:String, about:String) {
        UpdateProfileAPI.shared.update(userId: userId, fullName: fullName, mobileNo: mobileNo, city: city, address: address, state: state, country: country, postalCode: postalCode, about: about) { (data, serviceError, error) in
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
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(UserResponseCodable.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
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
                    let message = result.message
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
                        print("\(message ?? "Upload Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let userDetails = userData.first?.user {
                            self.handleUserState(with: userDetails)
                            let imageURL = userDetails.profilepic
                            self.profileImageURL = imageURL
                            self.fallBackToIdentity(with: .Success)
                            self.handleSuccess()
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                                iconImage: UIImage(named: "oho"))
                            alertview.setTextTheme(.light)
                            alertview.addAction({
                                self.fallBackToIdentity()
                            })
                        }
                        
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









extension CustomerSignupVCForm2 {
    internal func callUpdateProfilePictureSequence(imageURL: String, imageData:Data, userID:String) {
        ProfilePictureAPI.shared.upload(userId: userId, imageData: imageData, imageName: imageURL) { (data, serviceError, error) in
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
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SignInCodable.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
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
                    let message = result.message
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
                        print("\(message ?? "Upload Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let userDetails = userData.first?.user,
                            let imageURL = userDetails.profilepic,
                            !imageURL.isEmpty {
                            //                            self.handleUserState(with: userDetails)
                            self.profileImageURL = imageURL
                            self.fallBackToIdentity(with: .Success)
                            self.handleProfileUploadSuccess()
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                                iconImage: UIImage(named: "oho"))
                            alertview.setTextTheme(.light)
                            alertview.addAction({
                                self.fallBackToIdentity()
                            })
                        }
                        
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
    
    
    
    
    internal func callUpdateProfileSequence(userId: String, fullName:String, mobileNo:String, city:String, address:String, state:String, country:String, postalCode:String, about:String) {
        UpdateProfileAPI.shared.update(userId: userId, fullName: fullName, mobileNo: mobileNo, city: city, address: address, state: state, country: country, postalCode: postalCode, about: about) { (data, serviceError, error) in
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
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(UserResponseCodable.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
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
                    let message = result.message
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
                        print("\(message ?? "Upload Success")")
                        
                        let jsonString = String(data: data, encoding: .utf8)!
                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        
                        if let userData = result.data,
                            !userData.isEmpty,
                            let userDetails = userData.first?.user {
                            self.handleUserState(with: userDetails)
                            let imageURL = userDetails.profilepic
                            self.profileImageURL = imageURL
                            self.fallBackToIdentity(with: .Success)
                            self.handleSuccess()
                        } else {
                            print("API Internal Error: Rider MetaData & Details are nil")
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                                iconImage: UIImage(named: "oho"))
                            alertview.setTextTheme(.light)
                            alertview.addAction({
                                self.fallBackToIdentity()
                            })
                        }
                        
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
