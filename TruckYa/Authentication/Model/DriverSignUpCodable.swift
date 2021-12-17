//
//  DriverSignUpCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 04/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct DriverSignUpCodable : Codable {
    
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
            
            let id : String?
            let dlno : String?
            let email : String?
            let fullname : String?
            let mobileno : String?
//            let profilepic : AnyObject?
            
            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case dlno = "dlno"
                case email = "email"
                case fullname = "fullname"
                case mobileno = "mobileno"
//                case profilepic = "profilepic"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                dlno = try values.decodeIfPresent(String.self, forKey: .dlno)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
                mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
//                profilepic = try values.decodeIfPresent(AnyObject.self, forKey: .profilepic)
            }
            
        }
    }
}
