//
//  BookingPayloadCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct BookingPayloadCodable : Codable {

        let bookingid : String?
        let destination : String?
        let ridername : String?
        let source : String?
        let type : String?

        enum CodingKeys: String, CodingKey {
                case bookingid = "bookingid"
                case destination = "destination"
                case ridername = "ridername"
                case source = "source"
                case type = "type"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bookingid = try values.decodeIfPresent(String.self, forKey: .bookingid)
                destination = try values.decodeIfPresent(String.self, forKey: .destination)
                ridername = try values.decodeIfPresent(String.self, forKey: .ridername)
                source = try values.decodeIfPresent(String.self, forKey: .source)
                type = try values.decodeIfPresent(String.self, forKey: .type)
        }

}
