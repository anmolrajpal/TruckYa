//
//  DriverLoginCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 04/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct DriverLoginCodable : Codable {
    
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
            
            let v : Int?
            let id : String?
            let createdTs : String?
            let dlno : String?
            let email : String?
            let fullname : String?
//            let insurance : [AnyObject]?
            let mobileno : String?
            let password : String?
//            let profilepic : AnyObject?
            let radius : Int?
            let updatedTs : String?
            let usertype : String?
//            let vehicle : [AnyObject]?
            
            enum CodingKeys: String, CodingKey {
                case v = "__v"
                case id = "_id"
                case createdTs = "created_ts"
                case dlno = "dlno"
                case email = "email"
                case fullname = "fullname"
//                case insurance = "insurance"
                case mobileno = "mobileno"
                case password = "password"
//                case profilepic = "profilepic"
                case radius = "radius"
                case updatedTs = "updated_ts"
                case usertype = "usertype"
//                case vehicle = "vehicle"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                v = try values.decodeIfPresent(Int.self, forKey: .v)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                dlno = try values.decodeIfPresent(String.self, forKey: .dlno)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
//                insurance = try values.decodeIfPresent([AnyObject].self, forKey: .insurance)
                mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                password = try values.decodeIfPresent(String.self, forKey: .password)
//                profilepic = try values.decodeIfPresent(AnyObject.self, forKey: .profilepic)
                radius = try values.decodeIfPresent(Int.self, forKey: .radius)
                updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                usertype = try values.decodeIfPresent(String.self, forKey: .usertype)
//                vehicle = try values.decodeIfPresent([AnyObject].self, forKey: .vehicle)
            }
            
        }
    }
}
