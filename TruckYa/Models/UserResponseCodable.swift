//
//  UserResponseCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct UserResponseCodable : Codable {
    
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
        
        let user : User?
        
        enum CodingKeys: String, CodingKey {
            case user = "user"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            user = try values.decodeIfPresent(User.self, forKey: .user)
        }
        struct User : Codable {
            
            let v : Int?
            let id : String?
            let about : String?
            let address : String?
            let city : String?
            let country : String?
            let createdTs : String?
            let email : String?
            let fullname : String?
            let insurance : [Insurance]?
            let isinsuranceinfoset : Bool?
            let islisenseinfoset : Bool?
            let isprofileset : Bool?
            let isvehicleinfoset : Bool?
            let license : [License]?
            let mobileno : String?
            let otp : String?
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
                case fullname = "fullname"
                case insurance = "insurance"
                case isinsuranceinfoset = "isinsuranceinfoset"
                case islisenseinfoset = "islisenseinfoset"
                case isprofileset = "isprofileset"
                case isvehicleinfoset = "isvehicleinfoset"
                case license = "license"
                case mobileno = "mobileno"
                case otp = "otp"
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
                fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
                insurance = try values.decodeIfPresent([Insurance].self, forKey: .insurance)
                isinsuranceinfoset = try values.decodeIfPresent(Bool.self, forKey: .isinsuranceinfoset)
                islisenseinfoset = try values.decodeIfPresent(Bool.self, forKey: .islisenseinfoset)
                isprofileset = try values.decodeIfPresent(Bool.self, forKey: .isprofileset)
                isvehicleinfoset = try values.decodeIfPresent(Bool.self, forKey: .isvehicleinfoset)
                license = try values.decodeIfPresent([License].self, forKey: .license)
                mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                otp = try values.decodeIfPresent(String.self, forKey: .otp)
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
