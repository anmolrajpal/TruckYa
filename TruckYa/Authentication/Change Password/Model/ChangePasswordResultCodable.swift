//
//  ChangePasswordResultCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct ChangePasswordResultCodable : Codable {
    
    let errorcode : Int?
    let status : String?
    let message : String?
    let data : [Datum]?
    
    enum CodingKeys: String, CodingKey {
        case errorcode = "errorcode"
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorcode = try values.decodeIfPresent(Int.self, forKey: .errorcode)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([Datum].self, forKey: .data)
    }
    struct Datum : Codable {
        
        let token : String?
        let user : User?
        
        enum CodingKeys: String, CodingKey {
            case token = "token"
            case user = "user"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            token = try values.decodeIfPresent(String.self, forKey: .token)
            user = try values.decodeIfPresent(User.self, forKey: .user)
        }
        struct User : Codable {
            
            let profilepic : String?
            //            let vehicle : [AnyObject]?
            //            let license : [AnyObject]?
            //            let insurance : [AnyObject]?
            let radius : Int?
            let isprofileset : Bool?
            let isvehicleinfoset : Bool?
            let islisenseinfoset : Bool?
            let isinsuranceinfoset : Bool?
            let id : String?
            let fullname : String?
            let email : String?
            let password : String?
            let usertype : String?
            let mobileno : String?
            let createdTs : String?
            let updatedTs : String?
            let v : Int?
            let otp : String?
            
            enum CodingKeys: String, CodingKey {
                case profilepic = "profilepic"
                //                case vehicle = "vehicle"
                //                case license = "license"
                //                case insurance = "insurance"
                case radius = "radius"
                case isprofileset = "isprofileset"
                case isvehicleinfoset = "isvehicleinfoset"
                case islisenseinfoset = "islisenseinfoset"
                case isinsuranceinfoset = "isinsuranceinfoset"
                case id = "_id"
                case fullname = "fullname"
                case email = "email"
                case password = "password"
                case usertype = "usertype"
                case mobileno = "mobileno"
                case createdTs = "created_ts"
                case updatedTs = "updated_ts"
                case v = "__v"
                case otp = "otp"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                profilepic = try values.decodeIfPresent(String.self, forKey: .profilepic)
                //                vehicle = try values.decodeIfPresent([AnyObject].self, forKey: .vehicle)
                //                license = try values.decodeIfPresent([AnyObject].self, forKey: .license)
                //                insurance = try values.decodeIfPresent([AnyObject].self, forKey: .insurance)
                radius = try values.decodeIfPresent(Int.self, forKey: .radius)
                isprofileset = try values.decodeIfPresent(Bool.self, forKey: .isprofileset)
                isvehicleinfoset = try values.decodeIfPresent(Bool.self, forKey: .isvehicleinfoset)
                islisenseinfoset = try values.decodeIfPresent(Bool.self, forKey: .islisenseinfoset)
                isinsuranceinfoset = try values.decodeIfPresent(Bool.self, forKey: .isinsuranceinfoset)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                password = try values.decodeIfPresent(String.self, forKey: .password)
                usertype = try values.decodeIfPresent(String.self, forKey: .usertype)
                mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                v = try values.decodeIfPresent(Int.self, forKey: .v)
                otp = try values.decodeIfPresent(String.self, forKey: .otp)
            }
            
        }
    }
}
