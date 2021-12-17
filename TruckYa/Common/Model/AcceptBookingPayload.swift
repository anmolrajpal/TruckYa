//
//  AcceptBookingPayload.swift
//  TruckYa
//
//  Created by Digit Bazar on 28/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct AcceptBookingPayload: Codable {
    let aps : Aps?
    let bookingcode : String?
    let bookingid : String?
    let driverlat : String?
    let driverlong : String?
    let drivername : String?
    let gcmmessageId : String?
    let googlecae : String?
    let type : String?
    let vehicletype : String?
    enum CodingKeys: String, CodingKey {
        case aps = "aps"
        case bookingcode = "bookingcode"
        case bookingid = "bookingid"
        case driverlat = "driverlat"
        case driverlong = "driverlong"
        case drivername = "drivername"
        case gcmmessageId = "gcm.message_id"
        case googlecae = "google.c.a.e"
        case type = "type"
        case vehicletype = "vehicletype"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aps = try values.decodeIfPresent(Aps.self, forKey: .aps)
        bookingcode = try values.decodeIfPresent(String.self, forKey: .bookingcode)
        bookingid = try values.decodeIfPresent(String.self, forKey: .bookingid)
        driverlat = try values.decodeIfPresent(String.self, forKey: .driverlat)
        driverlong = try values.decodeIfPresent(String.self, forKey: .driverlong)
        drivername = try values.decodeIfPresent(String.self, forKey: .drivername)
        gcmmessageId = try values.decodeIfPresent(String.self, forKey: .gcmmessageId)
        googlecae = try values.decodeIfPresent(String.self, forKey: .googlecae)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        vehicletype = try values.decodeIfPresent(String.self, forKey: .vehicletype)
    }
    struct Aps : Codable {
        let alert : Alert?
        enum CodingKeys: String, CodingKey {
            case alert = "alert"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            alert = try values.decodeIfPresent(Alert.self, forKey: .alert)
        }
        struct Alert : Codable {
            let body : String?
            let title : String?
            enum CodingKeys: String, CodingKey {
                case body = "body"
                case title = "title"
            }
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                body = try values.decodeIfPresent(String.self, forKey: .body)
                title = try values.decodeIfPresent(String.self, forKey: .title)
            }
            
        }
    }
}
