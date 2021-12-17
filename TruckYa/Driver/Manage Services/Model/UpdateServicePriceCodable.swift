//
//  UpdateServicePriceCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct UpdateServicePriceCodable : Codable {

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

            let userservices : Userservice?

            enum CodingKeys: String, CodingKey {
                    case userservices = "userservices"
            }
        
            init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    userservices = try values.decodeIfPresent(Userservice.self, forKey: .userservices)
            }
        struct Userservice : Codable {

                let v : Int?
                let id : String?
                let createdTs : String?
                let driver : String?
                let hultingtodumpsdirtyjob : Float?
                let onedirverhelpsupload : Float?
                let stopanddrop : Float?
                let trailerhitchmove : Float?
                let twodirverhelpsupload : Float?
                let updatedTs : String?

                enum CodingKeys: String, CodingKey {
                        case v = "__v"
                        case id = "_id"
                        case createdTs = "created_ts"
                        case driver = "driver"
                        case hultingtodumpsdirtyjob = "hultingtodumpsdirtyjob"
                        case onedirverhelpsupload = "onedirverhelpsupload"
                        case stopanddrop = "stopanddrop"
                        case trailerhitchmove = "trailerhitchmove"
                        case twodirverhelpsupload = "twodirverhelpsupload"
                        case updatedTs = "updated_ts"
                }
            
                init(from decoder: Decoder) throws {
                        let values = try decoder.container(keyedBy: CodingKeys.self)
                        v = try values.decodeIfPresent(Int.self, forKey: .v)
                        id = try values.decodeIfPresent(String.self, forKey: .id)
                        createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                        driver = try values.decodeIfPresent(String.self, forKey: .driver)
                        hultingtodumpsdirtyjob = try values.decodeIfPresent(Float.self, forKey: .hultingtodumpsdirtyjob)
                        onedirverhelpsupload = try values.decodeIfPresent(Float.self, forKey: .onedirverhelpsupload)
                        stopanddrop = try values.decodeIfPresent(Float.self, forKey: .stopanddrop)
                        trailerhitchmove = try values.decodeIfPresent(Float.self, forKey: .trailerhitchmove)
                        twodirverhelpsupload = try values.decodeIfPresent(Float.self, forKey: .twodirverhelpsupload)
                        updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                }

        }
    }
}
