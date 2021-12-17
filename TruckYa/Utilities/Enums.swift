//
//  Enums.swift
//  TruckYa
//
//  Created by Digit Bazar on 01/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
public enum CustomFonts:String {
    //MARK: Gilroy
    case gilroyBlack = "Gilroy-Black"
    case gilroyBold = "Gilroy-Bold"
    case gilroyExtraBold = "Gilroy-ExtraBold"
    case gilroyHeavy = "Gilroy-Heavy"
    case gilroyLight = "Gilroy-Light"
    case gilroyMedium = "Gilroy-Medium"
    case gilroyRegular = "Gilroy-Regular"
    case gilroySemiBold = "Gilroy-SemiBold"
    case gilroyThin = "Gilroy-Thin"
    case gilroyUltraLight = "Gilroy-UltraLight"
    
    //MARK: Rajdhani
    case rajdhaniBold = "rajdhani-bold"
    case rajdhaniLight = "rajdhani-light"
    case rajdhaniMedium = "rajdhani-medium"
    case rajdhaniRegular = "rajdhani-regular"
    case rajdhaniSemiBold = "rajdhani-semibold"
    
    //MARK: Bebas Neue
    case bebasNeueBold = "BebasNeue-Bold"
    case bebasNeueBook = "BebasNeue-Book"
    case bebasNeueLight = "BebasNeue-Light"
    case bebasNeueRegular = "BebasNeue-Regular"
    case bebasNeueThin = "BebasNeue-Thin"
}



public enum CustomDateFormat: String {
    /// Time
    case time = "HH:mm:ss"
    case hmma = "h:mm a"
    
    /// Date with hours
    case dateWithTime = "yyyy-MM-dd HH:mm:ss"
    case dateWithTimeType1 = "dd/MM/yyyy hh:mm:ss"
    case dateTimeType2 = "MMMM d, h:mm a"

    /// Date
    case chatHeaderDate = "EEEE, MMM d, yyyy"
    case date = "dd/MM/yyyy"
    case dateType1 = "dd MMM, yyyy"
    case dateType2 = "MMM d"
    case MMMMdEEEE = "MMMM d EEEE"
    case ddMMMyyyy = "dd MMM yyyy"
    case cardExpiryDate = "MM/yyyy"
    case MMMMyyyy = "MMM, yyyy"
    
    //MARK: TimeStamp
    case timestamp = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}



public enum UserType:String {
    case Driver = "driver"
    case Customer = "rider"
}
public enum DriverScope {
    case Profile, Vehicle, License, Insurance, Dashboard
    static func getDriverScope(isProfileSet:Bool = UserDefaults.standard.isProfileSet, isVehicleInfoSet:Bool = UserDefaults.standard.isVehicleInfoSet, isLicenseInfoSet:Bool = UserDefaults.standard.isLicenseInfoSet, isInsuranceInfoSet:Bool = UserDefaults.standard.isInsuranceInfoSet) -> DriverScope {
//        let isProfileSet = UserDefaults.standard.isProfileSet
//        let isVehicleInfoSet = UserDefaults.standard.isVehicleInfoSet
//        let isLicenseInfoSet = UserDefaults.standard.isLicenseInfoSet
//        let isInsuranceInfoSet = UserDefaults.standard.isInsuranceInfoSet
        if !isProfileSet {
            return .Profile
        } else if !isVehicleInfoSet {
            return .Vehicle
        } else if !isLicenseInfoSet {
            return .License
        } else if !isInsuranceInfoSet {
            return .Insurance
        } else { return .Dashboard }
    }
    static func getDriverScopeOld() -> DriverScope {
        let isProfileSet = UserDefaults.standard.isProfileSet
        let isVehicleInfoSet = UserDefaults.standard.isVehicleInfoSet
        let isLicenseInfoSet = UserDefaults.standard.isLicenseInfoSet
        let isInsuranceInfoSet = UserDefaults.standard.isInsuranceInfoSet
        if isProfileSet && isVehicleInfoSet && isLicenseInfoSet && isInsuranceInfoSet {
            return .Dashboard
        } else if isProfileSet && isVehicleInfoSet && isLicenseInfoSet && !isInsuranceInfoSet {
            return .Insurance
        } else if isProfileSet && isVehicleInfoSet && !isLicenseInfoSet && !isInsuranceInfoSet {
            return .License
        } else if isProfileSet && !isVehicleInfoSet && !isLicenseInfoSet && !isInsuranceInfoSet {
            return .Vehicle
        } else { return .Profile }
    }
}
public enum CustomerScope {
    case Profile, Dashboard
    static func getCustomerScope(isProfileSet:Bool = UserDefaults.standard.isProfileSet) -> CustomerScope {
//        let isProfileSet = UserDefaults.standard.isProfileSet
        return !isProfileSet ? .Profile : .Dashboard
    }
}



public enum URLScheme:String {
    case http, https
}
public enum APIServiceError:Error {
    case apiError, InvalidEndpoint, InvalidResponse, FailedRequest, NoData, Internal, DecodeError, Unknown
}
public enum APIResultStatus:String {
    case Success = "success"
    case Error = "error"
}
public enum HTTPMethod:String {
    case GET, POST, PUT, DELETE
}
public enum ApplicationError:Error {
    case Internal(status:Int, message:String)
}

public enum ResponseStatus {
    //2xx
    case OK
    case Created
    case NoContent
    case Accepted
    //4xx
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case RequestTimeout
    case Conflict
    case Gone
    case PreconditionFailed
    case PayloadTooLarge
    case uriTooLong
    case UnsupportedMediaType
    case ExpectationFailed
    case MisdirectedRequest
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case TooManyRequests
    //5xx
    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    //Custom
    case UnknownResponse
    
    static func getStatusCode(by status:ResponseStatus) -> Int {
        switch status {
        //2xx
        case .OK: return 200
        case .Created: return 201
        case .Accepted: return 202
        case .NoContent: return 204
        //4xx
        case .BadRequest: return 400
        case .Unauthorized: return 401
        case .Forbidden: return 403
        case .NotFound: return 404
        case .MethodNotAllowed: return 405
        case .RequestTimeout: return 408
        case .Conflict: return 409
        case .Gone: return 410
        case .PreconditionFailed: return 412
        case .PayloadTooLarge: return 413
        case .uriTooLong: return 414
        case .UnsupportedMediaType: return 415
        case .ExpectationFailed: return 417
        case .MisdirectedRequest: return 421
        case .UnprocessableEntity: return 422
        case .Locked: return 423
        case .FailedDependency: return 424
        case .TooManyRequests: return 429
        //5xx
        case .InternalServerError: return 500
        case .NotImplemented: return 501
        case .BadGateway: return 502
        case .ServiceUnavailable: return 503
        //Unknown
        case .UnknownResponse: return 0
        }
    }
    
    static func getResponseStatusBy(statusCode:Int) -> ResponseStatus {
        switch statusCode {
        //2xx
        case 200: return .OK
        case 201: return .Created
        case 202: return .Accepted
        case 204: return .NoContent
        //4xx
        case 400: return .BadRequest
        case 401: return .Unauthorized
        case 403: return .Forbidden
        case 404: return .NotFound
        case 405: return .MethodNotAllowed
        case 408: return .RequestTimeout
        case 409: return .Conflict
        case 410: return .Gone
        case 412: return .PreconditionFailed
        case 413: return .PayloadTooLarge
        case 414: return .uriTooLong
        case 415: return .UnsupportedMediaType
        case 417: return .ExpectationFailed
        case 421: return .MisdirectedRequest
        case 422: return .UnprocessableEntity
        case 423: return .Locked
        case 424: return .FailedDependency
        case 429: return .TooManyRequests
        //5xx
        case 500: return .InternalServerError
        case 501: return .NotImplemented
        case 502: return .BadGateway
        case 503: return .ServiceUnavailable
        default: return .UnknownResponse
        }
    }
}
public enum Header {
    enum headerName:String {
        case contentType = "Content-Type"
        case accept = "Accept"
        case xRequestedWith = "X-Requested-With"
    }
    enum HeaderValue:String {
        case XMLHttpRequest = "XMLHttpRequest"
    }
    enum contentType:String {
        case json = "application/json"
        case xml = "application/xml"
        case urlEncoded = "application/x-www-form-urlencoded"
        case multipart = "multipart/form-data"
    }
    enum accept:String {
        case json = "application/json"
        case jsonFormatted = "application/json;indent=2"
        case xml = "application/xml"
    }
}
public enum TextFieldItemPosition { case Left, Right }
