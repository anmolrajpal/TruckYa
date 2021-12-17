//
//  CurrentBookings.swift
//  TruckYa
//
//  Created by Digit Bazar on 03/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct CurrentBookings: Codable {
    let data : [Datum]?
    let errorcode : Int?
    let message : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case errorcode = "errorcode"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Datum].self, forKey: .data)
        errorcode = try values.decodeIfPresent(Int.self, forKey: .errorcode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    struct Datum : Codable {
        
        let bookings : [Booking]?
        
        enum CodingKeys: String, CodingKey {
            case bookings = "bookings"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            bookings = try values.decodeIfPresent([Booking].self, forKey: .bookings)
        }
        struct Booking : Codable {
            
            let v : Int?
            let id : String?
//            let abortby : AnyObject?
            let bookingcode : String?
            let comments : String?
            let createdTs : String?
            let destination : String?
            let destlat : Double?
            let destlong : Double?
            let driver : Driver?
            let fare : Float?
            let hultingtodumpsdirtyjob : String?
            let onedriverhelpsupload : String?
            let paymentstatus : String?
            let rider : Rider?
            let source : String?
            let sourcelat : Double?
            let sourcelong : Double?
            let status : String?
            let stopanddrop : String?
            let trailerhitchmove : String?
            let twodriverhelpsupload : String?
            let updatedTs : String?
            
            enum CodingKeys: String, CodingKey {
                case v = "__v"
                case id = "_id"
//                case abortby = "abortby"
                case bookingcode = "bookingcode"
                case comments = "comments"
                case createdTs = "created_ts"
                case destination = "destination"
                case destlat = "destlat"
                case destlong = "destlong"
                case driver = "driver"
                case fare = "fare"
                case hultingtodumpsdirtyjob = "hultingtodumpsdirtyjob"
                case onedriverhelpsupload = "onedriverhelpsupload"
                case paymentstatus = "paymentstatus"
                case rider = "rider"
                case source = "source"
                case sourcelat = "sourcelat"
                case sourcelong = "sourcelong"
                case status = "status"
                case stopanddrop = "stopanddrop"
                case trailerhitchmove = "trailerhitchmove"
                case twodriverhelpsupload = "twodriverhelpsupload"
                case updatedTs = "updated_ts"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                v = try values.decodeIfPresent(Int.self, forKey: .v)
                id = try values.decodeIfPresent(String.self, forKey: .id)
//                abortby = try values.decodeIfPresent(AnyObject.self, forKey: .abortby)
                bookingcode = try values.decodeIfPresent(String.self, forKey: .bookingcode)
                comments = try values.decodeIfPresent(String.self, forKey: .comments)
                createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                destination = try values.decodeIfPresent(String.self, forKey: .destination)
                destlat = try values.decodeIfPresent(Double.self, forKey: .destlat)
                destlong = try values.decodeIfPresent(Double.self, forKey: .destlong)
                driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
                fare = try values.decodeIfPresent(Float.self, forKey: .fare)
                hultingtodumpsdirtyjob = try values.decodeIfPresent(String.self, forKey: .hultingtodumpsdirtyjob)
                onedriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .onedriverhelpsupload)
                paymentstatus = try values.decodeIfPresent(String.self, forKey: .paymentstatus)
                rider = try values.decodeIfPresent(Rider.self, forKey: .rider)
                source = try values.decodeIfPresent(String.self, forKey: .source)
                sourcelat = try values.decodeIfPresent(Double.self, forKey: .sourcelat)
                sourcelong = try values.decodeIfPresent(Double.self, forKey: .sourcelong)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                stopanddrop = try values.decodeIfPresent(String.self, forKey: .stopanddrop)
                trailerhitchmove = try values.decodeIfPresent(String.self, forKey: .trailerhitchmove)
                twodriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .twodriverhelpsupload)
                updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
            }
            struct Rider : Codable {
                
                let v : Int?
                let id : String?
                let about : String?
                let address : String?
                let city : String?
                let country : String?
                let createdTs : String?
                let email : String?
                let fcmtoken : String?
                let fullname : String?
//                let insurance : [AnyObject]?
                let isinsuranceinfoset : Bool?
                let islisenseinfoset : Bool?
                let isprofileset : Bool?
                let isvehicleinfoset : Bool?
                let lat : Double?
//                let license : [AnyObject]?
                let longField : Double?
                let mobileno : String?
                let password : String?
                let profilepic : String?
                let radius : Int?
                let state : String?
                let updatedTs : String?
                let usertype : String?
//                let vehicle : [AnyObject]?
                let zipcode : String?
                
                enum CodingKeys: String, CodingKey {
                    case v = "__v"
                    case id = "_id"
                    case about = "about"
                    case address = "address"
                    case city = "city"
                    case country = "country"
                    case createdTs = "created_ts"
                    case email = "email"
                    case fcmtoken = "fcmtoken"
                    case fullname = "fullname"
//                    case insurance = "insurance"
                    case isinsuranceinfoset = "isinsuranceinfoset"
                    case islisenseinfoset = "islisenseinfoset"
                    case isprofileset = "isprofileset"
                    case isvehicleinfoset = "isvehicleinfoset"
                    case lat = "lat"
//                    case license = "license"
                    case longField = "long"
                    case mobileno = "mobileno"
                    case password = "password"
                    case profilepic = "profilepic"
                    case radius = "radius"
                    case state = "state"
                    case updatedTs = "updated_ts"
                    case usertype = "usertype"
//                    case vehicle = "vehicle"
                    case zipcode = "zipcode"
                }
                
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    v = try values.decodeIfPresent(Int.self, forKey: .v)
                    id = try values.decodeIfPresent(String.self, forKey: .id)
                    about = try values.decodeIfPresent(String.self, forKey: .about)
                    address = try values.decodeIfPresent(String.self, forKey: .address)
                    city = try values.decodeIfPresent(String.self, forKey: .city)
                    country = try values.decodeIfPresent(String.self, forKey: .country)
                    createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                    email = try values.decodeIfPresent(String.self, forKey: .email)
                    fcmtoken = try values.decodeIfPresent(String.self, forKey: .fcmtoken)
                    fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
//                    insurance = try values.decodeIfPresent([AnyObject].self, forKey: .insurance)
                    isinsuranceinfoset = try values.decodeIfPresent(Bool.self, forKey: .isinsuranceinfoset)
                    islisenseinfoset = try values.decodeIfPresent(Bool.self, forKey: .islisenseinfoset)
                    isprofileset = try values.decodeIfPresent(Bool.self, forKey: .isprofileset)
                    isvehicleinfoset = try values.decodeIfPresent(Bool.self, forKey: .isvehicleinfoset)
                    lat = try values.decodeIfPresent(Double.self, forKey: .lat)
//                    license = try values.decodeIfPresent([AnyObject].self, forKey: .license)
                    longField = try values.decodeIfPresent(Double.self, forKey: .longField)
                    mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                    password = try values.decodeIfPresent(String.self, forKey: .password)
                    profilepic = try values.decodeIfPresent(String.self, forKey: .profilepic)
                    radius = try values.decodeIfPresent(Int.self, forKey: .radius)
                    state = try values.decodeIfPresent(String.self, forKey: .state)
                    updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                    usertype = try values.decodeIfPresent(String.self, forKey: .usertype)
//                    vehicle = try values.decodeIfPresent([AnyObject].self, forKey: .vehicle)
                    zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
                }
                
            }
            struct Driver : Codable {
                
                let v : Int?
                let id : String?
                let about : String?
                let address : String?
                let city : String?
                let country : String?
                let createdTs : String?
                let email : String?
                let fcmtoken : String?
                let fullname : String?
                let insurance : [Insurance]?
                let isinsuranceinfoset : Bool?
                let islisenseinfoset : Bool?
                let isprofileset : Bool?
                let isvehicleinfoset : Bool?
                let lat : Double?
                let license : [License]?
                let longField : Double?
                let mobileno : String?
                let password : String?
                let profilepic : String?
                let radius : Int?
                let state : String?
                let updatedTs : String?
                let usertype : String?
                let vehicle : [Vehicle]?
                let zipcode : String?
                
                enum CodingKeys: String, CodingKey {
                    case v = "__v"
                    case id = "_id"
                    case about = "about"
                    case address = "address"
                    case city = "city"
                    case country = "country"
                    case createdTs = "created_ts"
                    case email = "email"
                    case fcmtoken = "fcmtoken"
                    case fullname = "fullname"
                    case insurance = "insurance"
                    case isinsuranceinfoset = "isinsuranceinfoset"
                    case islisenseinfoset = "islisenseinfoset"
                    case isprofileset = "isprofileset"
                    case isvehicleinfoset = "isvehicleinfoset"
                    case lat = "lat"
                    case license = "license"
                    case longField = "long"
                    case mobileno = "mobileno"
                    case password = "password"
                    case profilepic = "profilepic"
                    case radius = "radius"
                    case state = "state"
                    case updatedTs = "updated_ts"
                    case usertype = "usertype"
                    case vehicle = "vehicle"
                    case zipcode = "zipcode"
                }
                
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    v = try values.decodeIfPresent(Int.self, forKey: .v)
                    id = try values.decodeIfPresent(String.self, forKey: .id)
                    about = try values.decodeIfPresent(String.self, forKey: .about)
                    address = try values.decodeIfPresent(String.self, forKey: .address)
                    city = try values.decodeIfPresent(String.self, forKey: .city)
                    country = try values.decodeIfPresent(String.self, forKey: .country)
                    createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                    email = try values.decodeIfPresent(String.self, forKey: .email)
                    fcmtoken = try values.decodeIfPresent(String.self, forKey: .fcmtoken)
                    fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
                    insurance = try values.decodeIfPresent([Insurance].self, forKey: .insurance)
                    isinsuranceinfoset = try values.decodeIfPresent(Bool.self, forKey: .isinsuranceinfoset)
                    islisenseinfoset = try values.decodeIfPresent(Bool.self, forKey: .islisenseinfoset)
                    isprofileset = try values.decodeIfPresent(Bool.self, forKey: .isprofileset)
                    isvehicleinfoset = try values.decodeIfPresent(Bool.self, forKey: .isvehicleinfoset)
                    lat = try values.decodeIfPresent(Double.self, forKey: .lat)
                    license = try values.decodeIfPresent([License].self, forKey: .license)
                    longField = try values.decodeIfPresent(Double.self, forKey: .longField)
                    mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                    password = try values.decodeIfPresent(String.self, forKey: .password)
                    profilepic = try values.decodeIfPresent(String.self, forKey: .profilepic)
                    radius = try values.decodeIfPresent(Int.self, forKey: .radius)
                    state = try values.decodeIfPresent(String.self, forKey: .state)
                    updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                    usertype = try values.decodeIfPresent(String.self, forKey: .usertype)
                    vehicle = try values.decodeIfPresent([Vehicle].self, forKey: .vehicle)
                    zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
                }
                struct Vehicle : Codable {
                    
                    let vehiclecolor : String?
                    let vehicleimage : String?
                    let vehicleplateno : String?
                    let vehicletype : String?
                    
                    enum CodingKeys: String, CodingKey {
                        case vehiclecolor = "vehiclecolor"
                        case vehicleimage = "vehicleimage"
                        case vehicleplateno = "vehicleplateno"
                        case vehicletype = "vehicletype"
                    }
                    
                    init(from decoder: Decoder) throws {
                        let values = try decoder.container(keyedBy: CodingKeys.self)
                        vehiclecolor = try values.decodeIfPresent(String.self, forKey: .vehiclecolor)
                        vehicleimage = try values.decodeIfPresent(String.self, forKey: .vehicleimage)
                        vehicleplateno = try values.decodeIfPresent(String.self, forKey: .vehicleplateno)
                        vehicletype = try values.decodeIfPresent(String.self, forKey: .vehicletype)
                    }
                    
                }
                struct License : Codable {
                    
                    let issuedate : String?
                    let licenseno : String?
                    let lisenseimage : String?
                    let tilldate : String?
                    
                    enum CodingKeys: String, CodingKey {
                        case issuedate = "issuedate"
                        case licenseno = "licenseno"
                        case lisenseimage = "lisenseimage"
                        case tilldate = "tilldate"
                    }
                    
                    init(from decoder: Decoder) throws {
                        let values = try decoder.container(keyedBy: CodingKeys.self)
                        issuedate = try values.decodeIfPresent(String.self, forKey: .issuedate)
                        licenseno = try values.decodeIfPresent(String.self, forKey: .licenseno)
                        lisenseimage = try values.decodeIfPresent(String.self, forKey: .lisenseimage)
                        tilldate = try values.decodeIfPresent(String.self, forKey: .tilldate)
                    }
                    
                }
                struct Insurance : Codable {
                    
                    let companyname : String?
                    let insuraceimage : String?
                    let insuraceno : String?
                    let insuranceamount : String?
                    let issuedate : String?
                    let tilldate : String?
                    
                    enum CodingKeys: String, CodingKey {
                        case companyname = "companyname"
                        case insuraceimage = "insuraceimage"
                        case insuraceno = "insuraceno"
                        case insuranceamount = "insuranceamount"
                        case issuedate = "issuedate"
                        case tilldate = "tilldate"
                    }
                    
                    init(from decoder: Decoder) throws {
                        let values = try decoder.container(keyedBy: CodingKeys.self)
                        companyname = try values.decodeIfPresent(String.self, forKey: .companyname)
                        insuraceimage = try values.decodeIfPresent(String.self, forKey: .insuraceimage)
                        insuraceno = try values.decodeIfPresent(String.self, forKey: .insuraceno)
                        insuranceamount = try values.decodeIfPresent(String.self, forKey: .insuranceamount)
                        issuedate = try values.decodeIfPresent(String.self, forKey: .issuedate)
                        tilldate = try values.decodeIfPresent(String.self, forKey: .tilldate)
                    }
                    
                }
            }
        }
    }
    
}
