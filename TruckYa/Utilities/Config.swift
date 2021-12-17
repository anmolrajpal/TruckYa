//
//  Config.swift
//  TruckYa
//
//  Created by Digit Bazar on 31/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation

struct Config {
    struct FirebaseConfig {
        struct CloudMessagingConfig {
            static let SenderID = "36690022558"
        }
    }
    struct MapsConfig {
        static let GMS_API_KEY = "AIzaSyAzrmC8yjM1qOjf8_oPZ9U8M5-ZpVTZIkg"
    }
    struct PaymentConfig {
//        static let stripeKey = "pk_test_jXFvWaZdUhb7bXCZ1CQNtjL8004IBTu9vR"
        static let stripeKey = "pk_live_w9KAz1waw1m4MTPN5WW9h0Cj00MCBJo8tK"
    }
    struct EndpointConfig {
        static let timeOutInterval:TimeInterval = 15.0
        static let apiURLScheme = URLScheme.http.rawValue
        static let baseURL = "http://3.130.157.207:3032"
        static let apiHost = "3.130.157.207"
        static let port:Int = 3032
        static let apiCommonPath:String = "/api"
        enum EndpointPath:String {
            //MARK: Pages
            case PrivacyPolicy = "/pages/privacy-policy.html"
            case TermsAndConditions = "/pages/terms-and-condition.html"
            case HelpAndSupport = "/pages/help-and-support.html"
            
            //MARK: Users
            case SignIn = "/users/login"
            case SignUp = "/users/signup"
            case ForgotPassword = "/users/forgotpassword"
            case VerifyOTP = "/users/varifyotp"
            case ChangePassword = "/users/changepassword"
            case UpdateProfilePicture = "/users/updateprofilepic"
            case UpdateProfile = "/users/updateprofile"
            case UpdateVehicleInfo = "/users/addvehicleinfo"
            case UpdateLicenseInfo = "/users/addlicenseinfo"
            case UpdateInsuranceInfo = "/users/addinsuranceinfo"
            case UpdateServicePrice = "/users/updateserviceprice"
            case GetServicePrice = "/users/getuserservices"
            case UpdateFCMToken = "/users/updatefcmtoken"
            case UpdateCurrentLocation = "/users/updatecurrentlocation"
            
            // MARK: Bookings
            case FetchNearbyDrivers = "/bookings/getdrivernearby"
            case RequestBooking = "/bookings/requestbooking"
            case AcceptBooking = "/bookings/acceptbooking"
            case DeclineBooking = "/bookings/declinebooking"
            case GetDriverLocation = "/bookings/getdriverlocation"
            case DriverReachedToSource = "/bookings/driverreached"
            case StartTrip = "/bookings/startjourney"
            case StopTrip = "/bookings/stopjourney"
            case GetCurrentBookings = "/bookings/getcurrentbookings"
            case GetMyBookings = "/bookings/getmybooking"
            case MakePayment = "/bookings/paynow"
        
            //MARK: Payments
            case GetAllCards = "/stripe/getallcards"
            case SaveCustomerCard = "/stripe/savecustomercard"
            
        }
        static func getEndpointURLPath(for endpointPath:EndpointPath) -> String {
            switch endpointPath {
                //MARK: Pages
                case .PrivacyPolicy : return EndpointPath.PrivacyPolicy.rawValue
                case .TermsAndConditions : return EndpointPath.TermsAndConditions.rawValue
                case .HelpAndSupport: return EndpointPath.HelpAndSupport.rawValue
                
                //MARK: Users
                case .SignIn : return apiCommonPath + EndpointPath.SignIn.rawValue
                case .SignUp : return apiCommonPath + EndpointPath.SignUp.rawValue
                case .ForgotPassword: return apiCommonPath + EndpointPath.ForgotPassword.rawValue
                case .VerifyOTP: return apiCommonPath + EndpointPath.VerifyOTP.rawValue
                case .ChangePassword: return apiCommonPath + EndpointPath.ChangePassword.rawValue
                case .UpdateProfilePicture: return apiCommonPath + EndpointPath.UpdateProfilePicture.rawValue
                case .UpdateProfile: return apiCommonPath + EndpointPath.UpdateProfile.rawValue
                case .UpdateVehicleInfo: return apiCommonPath + EndpointPath.UpdateVehicleInfo.rawValue
                case .UpdateLicenseInfo: return apiCommonPath + EndpointPath.UpdateLicenseInfo.rawValue
                case .UpdateInsuranceInfo: return apiCommonPath + EndpointPath.UpdateInsuranceInfo.rawValue
                case .UpdateServicePrice: return apiCommonPath + EndpointPath.UpdateServicePrice.rawValue
                case .GetServicePrice: return apiCommonPath + EndpointPath.GetServicePrice.rawValue
                case .UpdateFCMToken: return apiCommonPath + EndpointPath.UpdateFCMToken.rawValue
                case .UpdateCurrentLocation: return apiCommonPath + EndpointPath.UpdateCurrentLocation.rawValue
                // MARK: Bookings
                case .FetchNearbyDrivers: return apiCommonPath + EndpointPath.FetchNearbyDrivers.rawValue
                case .RequestBooking: return apiCommonPath + EndpointPath.RequestBooking.rawValue
                case .AcceptBooking: return apiCommonPath + EndpointPath.AcceptBooking.rawValue
                case .DeclineBooking: return apiCommonPath + EndpointPath.DeclineBooking.rawValue
                case .GetDriverLocation: return apiCommonPath + EndpointPath.GetDriverLocation.rawValue
                case .DriverReachedToSource: return apiCommonPath + EndpointPath.DriverReachedToSource.rawValue
                case .StartTrip: return apiCommonPath + EndpointPath.StartTrip.rawValue
                case .StopTrip: return apiCommonPath + EndpointPath.StopTrip.rawValue
                case .GetCurrentBookings: return apiCommonPath + EndpointPath.GetCurrentBookings.rawValue
                case .GetMyBookings: return apiCommonPath + EndpointPath.GetMyBookings.rawValue
                case .MakePayment: return apiCommonPath + EndpointPath.MakePayment.rawValue
                //MARK: Payments
                case .GetAllCards: return apiCommonPath + EndpointPath.GetAllCards.rawValue
                case .SaveCustomerCard: return apiCommonPath + EndpointPath.SaveCustomerCard.rawValue
            }
        }
    }
}
