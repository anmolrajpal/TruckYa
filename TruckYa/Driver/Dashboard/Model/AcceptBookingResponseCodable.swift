//
//  AcceptBookingResponseCodable.swift
//  TruckYa
//
//  Created by Digit Bazar on 27/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct AcceptBookingResponseCodable : Codable {

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

            let booking : Booking?

            enum CodingKeys: String, CodingKey {
                    case booking = "booking"
            }
        
            init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    booking = try values.decodeIfPresent(Booking.self, forKey: .booking)
            }
        struct Booking : Codable {

                let v : Int?
                let id : String?
//                let abortby : AnyObject?
                let bookingcode : String?
                let comments : String?
                let createdTs : String?
                let destination : String?
                let destlat : Double?
                let destlong : Double?
                let driver : String?
                let fare : Float?
                let hultingtodumpsdirtyjob : String?
                let onedriverhelpsupload : String?
                let paymentstatus : String?
                let rider : String?
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
//                        case abortby = "abortby"
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
//                        abortby = try values.decodeIfPresent(AnyObject.self, forKey: .abortby)
                        bookingcode = try values.decodeIfPresent(String.self, forKey: .bookingcode)
                        comments = try values.decodeIfPresent(String.self, forKey: .comments)
                        createdTs = try values.decodeIfPresent(String.self, forKey: .createdTs)
                        destination = try values.decodeIfPresent(String.self, forKey: .destination)
                        destlat = try values.decodeIfPresent(Double.self, forKey: .destlat)
                        destlong = try values.decodeIfPresent(Double.self, forKey: .destlong)
                        driver = try values.decodeIfPresent(String.self, forKey: .driver)
                        fare = try values.decodeIfPresent(Float.self, forKey: .fare)
                        hultingtodumpsdirtyjob = try values.decodeIfPresent(String.self, forKey: .hultingtodumpsdirtyjob)
                        onedriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .onedriverhelpsupload)
                        paymentstatus = try values.decodeIfPresent(String.self, forKey: .paymentstatus)
                        rider = try values.decodeIfPresent(String.self, forKey: .rider)
                        source = try values.decodeIfPresent(String.self, forKey: .source)
                        sourcelat = try values.decodeIfPresent(Double.self, forKey: .sourcelat)
                        sourcelong = try values.decodeIfPresent(Double.self, forKey: .sourcelong)
                        status = try values.decodeIfPresent(String.self, forKey: .status)
                        stopanddrop = try values.decodeIfPresent(String.self, forKey: .stopanddrop)
                        trailerhitchmove = try values.decodeIfPresent(String.self, forKey: .trailerhitchmove)
                        twodriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .twodriverhelpsupload)
                        updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                }

        }
    }
}
