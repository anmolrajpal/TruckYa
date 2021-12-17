//
//  UserDefauls.swift
//  TruckYa
//
//  Created by Digit Bazar on 04/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import CoreLocation


@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

@propertyWrapper
struct EncryptedStringStorage {

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String {
        get {
            // Get encrypted string from UserDefaults
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            // Encrypt newValue before set to UserDefaults
            let encrypted = encrypt(value: newValue)
            UserDefaults.standard.set(encrypted, forKey: key)
        }
    }

    private func encrypt(value: String) -> String {
        // Encryption logic here
        return String(value.reversed())
    }
}

struct AppData {
    @Storage(key: "username_key", defaultValue: "")
    static var username: String

    @Storage(key: "enable_auto_login_key", defaultValue: false)
    static var enableAutoLogin: Bool
    
    // Declare a User object
//    @Storage(key: "userDetails", defaultValue: nil)
//    static var userDetails: UserResponseCodable.Datum.User?
    
    
    static var userDetails:UserResponseCodable.Datum.User? {
        get {
            guard let data = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.userDetails.rawValue) as? Data else {
                return nil
            }
            let value = try? JSONDecoder().decode(UserResponseCodable.Datum.User.self, from: data)
            return value ?? nil
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: UserDefaults.UserDefaultsKeys.userDetails.rawValue)
        }
    }
    
    @EncryptedStringStorage(key: "password_key")
    static var password: String
}


//AppData.username = "swift-senpai"
//print(AppData.username) // swift-senpai
//AppData.enableAutoLogin = true
//print(AppData.enableAutoLogin)  // true
//let johnWick = User(firstName: "John", lastName: "Wick", lastLogin: Date())
//AppData.user = johnWick
//print(AppData.user.firstName) // John
//print(AppData.user.lastName) // Wick
//print(AppData.user.lastLogin!) // 2019-10-06 09:40:26 +0000
//AppData.password = "password1234"
//print(AppData.password) // 4321drowssap






extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn, appLaunchCount, userType, userProfileImageURL, userName, userEmail, userID, userMobile, userAddress, userCity, userState, userCountry, userPostalCode, userDescription, isProfileSet, isVehicleInfoSet, isLicenseInfoSet, isInsuranceInfoSet, driverPushBoookingID, driverPushCustomerName, driverPushDestinationAddress, driverPushSourceAddress, sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude, isDriverReachingSource, isDriverReachingDestination, userDetails
    }
    var appLaunchCount:Int? {
        get {
            return integer(forKey: UserDefaultsKeys.appLaunchCount.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.appLaunchCount.rawValue)
        }
    }
    
    var isLoggedIn:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
    }
    var isProfileSet:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isProfileSet.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isProfileSet.rawValue)
        }
    }
    var isVehicleInfoSet:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isVehicleInfoSet.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isVehicleInfoSet.rawValue)
        }
    }
    var isLicenseInfoSet:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isLicenseInfoSet.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isLicenseInfoSet.rawValue)
        }
    }
    var isInsuranceInfoSet:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isInsuranceInfoSet.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isInsuranceInfoSet.rawValue)
        }
    }
    var userType:UserType? {
        get {
            return UserType(rawValue: string(forKey: UserDefaultsKeys.userType.rawValue) ?? "")
        }
        set {
            set(newValue!.rawValue, forKey: UserDefaultsKeys.userType.rawValue)
        }
    }
//    var userDetails:String? {
//        get {
//            return string(forKey: UserDefaultsKeys.userDetails.rawValue)
//        }
//        set {
//            set(newValue, forKey: UserDefaultsKeys.userDetails.rawValue)
//        }
//    }
    var userProfileImageURL:String? {
        get {
            return string(forKey: UserDefaultsKeys.userProfileImageURL.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userProfileImageURL.rawValue)
        }
    }
    var userName:String? {
        get {
            return string(forKey: UserDefaultsKeys.userName.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userName.rawValue)
        }
    }
    var userEmail:String? {
        get {
            return string(forKey: UserDefaultsKeys.userEmail.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userEmail.rawValue)
        }
    }
    var userID:String? {
        get {
            return string(forKey: UserDefaultsKeys.userID.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userID.rawValue)
        }
    }
    var userMobile:String? {
        get {
            return string(forKey: UserDefaultsKeys.userMobile.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userMobile.rawValue)
        }
    }
    var userAddress:String? {
        get {
            return string(forKey: UserDefaultsKeys.userAddress.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userAddress.rawValue)
        }
    }
    var userCity:String? {
        get {
            return string(forKey: UserDefaultsKeys.userCity.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userCity.rawValue)
        }
    }
    var userState:String? {
        get {
            return string(forKey: UserDefaultsKeys.userState.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userState.rawValue)
        }
    }
    var userCountry:String? {
        get {
            return string(forKey: UserDefaultsKeys.userCountry.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userCountry.rawValue)
        }
    }
    var userPostalCode:String? {
        get {
            return string(forKey: UserDefaultsKeys.userPostalCode.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userPostalCode.rawValue)
        }
    }
    var userDescription:String? {
        get {
            return string(forKey: UserDefaultsKeys.userDescription.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userDescription.rawValue)
        }
    }
    var driverPushBoookingID:String? {
        get {
            return string(forKey: UserDefaultsKeys.driverPushBoookingID.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.driverPushBoookingID.rawValue)
        }
    }
    var driverPushCustomerName:String? {
        get {
            return string(forKey: UserDefaultsKeys.driverPushCustomerName.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.driverPushCustomerName.rawValue)
        }
    }
    var driverPushSourceAddress:String? {
        get {
            return string(forKey: UserDefaultsKeys.driverPushSourceAddress.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.driverPushSourceAddress.rawValue)
        }
    }
    var driverPushDestinationAddress:String? {
        get {
            return string(forKey: UserDefaultsKeys.driverPushDestinationAddress.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.driverPushDestinationAddress.rawValue)
        }
    }
    var sourceLatitude:Double? {
        get {
            return double(forKey: UserDefaultsKeys.sourceLatitude.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.sourceLatitude.rawValue)
        }
    }
    var sourceLongitude:Double? {
        get {
            return double(forKey: UserDefaultsKeys.sourceLongitude.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.sourceLongitude.rawValue)
        }
    }
    var destinationLatitude:Double? {
        get {
            return double(forKey: UserDefaultsKeys.destinationLatitude.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.destinationLatitude.rawValue)
        }
    }
    var destinationLongitude:Double? {
        get {
            return double(forKey: UserDefaultsKeys.destinationLongitude.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.destinationLongitude.rawValue)
        }
    }
    var isDriverReachingSource:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isDriverReachingSource.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isDriverReachingSource.rawValue)
        }
    }
    var isDriverReachingDestination:Bool {
        get {
            return bool(forKey: UserDefaultsKeys.isInsuranceInfoSet.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isDriverReachingDestination.rawValue)
        }
    }
    static func saveSourceCoordinates(coordinates: CLLocationCoordinate2D) {
        UserDefaults.standard.sourceLatitude = coordinates.latitude
        UserDefaults.standard.sourceLongitude = coordinates.longitude
    }
    static func saveDestinationCoordinates(coordinates: CLLocationCoordinate2D) {
        UserDefaults.standard.destinationLatitude = coordinates.latitude
        UserDefaults.standard.destinationLongitude = coordinates.longitude
    }
    static func clearSourceCoordinates() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sourceLatitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sourceLongitude.rawValue)
    }
    static func clearDestinationCoordinates() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.destinationLatitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.destinationLongitude.rawValue)
    }
    static func getSourceCoordinates() -> CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.sourceLatitude ?? 50
        let longitude = UserDefaults.standard.sourceLongitude ?? 50
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinates
    }
    static func getDestinationCoordinates() -> CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.destinationLatitude ?? 50
        let longitude = UserDefaults.standard.destinationLongitude ?? 50
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinates
    }
    static func saveUserDetails(details: UserResponseCodable.Datum.User) {
        UserDefaults.standard.userName =  details.fullname
        UserDefaults.standard.userEmail = details.email
        UserDefaults.standard.userMobile = details.mobileno
        UserDefaults.standard.userID = details.id
        UserDefaults.standard.userProfileImageURL = details.profilepic
        UserDefaults.standard.userAddress =  details.address
        UserDefaults.standard.userCity = details.city
        UserDefaults.standard.userState = details.state
        UserDefaults.standard.userCountry = details.country
        UserDefaults.standard.userPostalCode =  details.zipcode
        UserDefaults.standard.userDescription = details.about
    }
    static func saveUserDetails(details: SignUpCodable.Datum.User) {
        UserDefaults.standard.userName =  details.fullname
        UserDefaults.standard.userEmail = details.email
        UserDefaults.standard.userMobile = details.mobileno
        UserDefaults.standard.userID = details.id
    }
    static func saveDriverScope(isProfileSet:Bool, isVehicleInfoSet:Bool, isLicenseInfoSet:Bool, isInsuranceInfoSet:Bool) {
        UserDefaults.standard.isProfileSet = isProfileSet
        UserDefaults.standard.isVehicleInfoSet = isVehicleInfoSet
        UserDefaults.standard.isLicenseInfoSet = isLicenseInfoSet
        UserDefaults.standard.isInsuranceInfoSet = isInsuranceInfoSet
    }
    static func saveCustomerScope(isProfileSet:Bool) {
        UserDefaults.standard.isProfileSet = isProfileSet
    }
    static func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userProfileImageURL.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userType.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userName.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userMobile.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userAddress.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userCity.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userState.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userCountry.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userPostalCode.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userDescription.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isProfileSet.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isVehicleInfoSet.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLicenseInfoSet.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isInsuranceInfoSet.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverPushBoookingID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverPushCustomerName.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverPushSourceAddress.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverPushDestinationAddress.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sourceLatitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sourceLongitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.destinationLatitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.destinationLongitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isDriverReachingSource.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isDriverReachingDestination.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userDetails.rawValue)
    }
}

