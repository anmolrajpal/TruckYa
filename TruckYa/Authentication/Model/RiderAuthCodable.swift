//
//  SignInCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 31/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation

struct RiderAuthCodable : Codable {
    
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
            let mobileno : String?
            let usertype : String?
            
            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case mobileno = "mobileno"
                case usertype = "usertype"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
                usertype = try values.decodeIfPresent(String.self, forKey: .usertype)
            }
        }
    }
}
