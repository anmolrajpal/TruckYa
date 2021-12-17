//
//  OtpVCDataProvider.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
extension OtpVC {
    internal func callVerifyOTPSequence(for email:String, with otp:String) {
        OTP_API.shared.verifyOTP(for: email, with: otp) { (data, serviceError, error) in
            if let error = error {
                print("OTP Error: \(error.localizedDescription)")
                self.errorLabel.text = error.localizedDescription
                self.handleInvalidOTPState()
            } else if let serviceError = serviceError {
                print("OTP Service Error: \(serviceError.localizedDescription)")
                self.errorLabel.text = serviceError.localizedDescription
                self.handleInvalidOTPState()
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let result = try decoder.decode(VerifyOTPResultCodable.self, from: data)
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        self.errorLabel.text = "Service Error. Please try Again in a while"
                        self.handleInvalidOTPState()
                        return
                    }
                    let message = result.message
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        self.errorLabel.text = message
                        self.handleInvalidOTPState()
                        self.fallBackToIdentity()
                    case .Success:
                        print("Success")
                        
                        print("\(message ?? "FP Success")")
                        guard let userId:String = result.data?.first?.user?.id else {
                            self.errorLabel.text = "Service Error: UserID not found"
                            self.handleInvalidOTPState()
                            self.fallBackToIdentity()
                            return
                        }
                        print("UserID => \(userId)")
                        self.fallBackToIdentity(with: .Success)
                        self.handleSuccess(forUserWithID: userId)
                    case .none: print("Unknown Case")
                    self.errorLabel.text = "Service Internal Error. Please contact support"
                    self.handleInvalidOTPState()
                        break
                    }
                    
                } catch let err {
                    self.errorLabel.text = err.localizedDescription
                    self.handleInvalidOTPState()
                }
            }
        }
    }
}
