//
//  PaymentResponse.swift
//  TruckYa
//
//  Created by Digit Bazar on 04/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
struct PaymentResponse : Codable {

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
                let destlat : Float?
                let destlong : Float?
                let driver : String?
                let fare : Float?
                let hultingtodumpsdirtyjob : String?
                let onedriverhelpsupload : String?
                let paymentdata : Paymentdatum?
                let paymentstatus : String?
                let rider : String?
                let source : String?
                let sourcelat : Float?
                let sourcelong : Float?
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
                        case paymentdata = "paymentdata"
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
                        destlat = try values.decodeIfPresent(Float.self, forKey: .destlat)
                        destlong = try values.decodeIfPresent(Float.self, forKey: .destlong)
                        driver = try values.decodeIfPresent(String.self, forKey: .driver)
                        fare = try values.decodeIfPresent(Float.self, forKey: .fare)
                        hultingtodumpsdirtyjob = try values.decodeIfPresent(String.self, forKey: .hultingtodumpsdirtyjob)
                        onedriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .onedriverhelpsupload)
                        paymentdata = try values.decodeIfPresent(Paymentdatum.self, forKey: .paymentdata)
                        paymentstatus = try values.decodeIfPresent(String.self, forKey: .paymentstatus)
                        rider = try values.decodeIfPresent(String.self, forKey: .rider)
                        source = try values.decodeIfPresent(String.self, forKey: .source)
                        sourcelat = try values.decodeIfPresent(Float.self, forKey: .sourcelat)
                        sourcelong = try values.decodeIfPresent(Float.self, forKey: .sourcelong)
                        status = try values.decodeIfPresent(String.self, forKey: .status)
                        stopanddrop = try values.decodeIfPresent(String.self, forKey: .stopanddrop)
                        trailerhitchmove = try values.decodeIfPresent(String.self, forKey: .trailerhitchmove)
                        twodriverhelpsupload = try values.decodeIfPresent(String.self, forKey: .twodriverhelpsupload)
                        updatedTs = try values.decodeIfPresent(String.self, forKey: .updatedTs)
                }
            struct Paymentdatum : Codable {

                    let amount : Int?
                    let amountRefunded : Int?
//                    let application : AnyObject?
//                    let applicationFee : AnyObject?
//                    let applicationFeeAmount : AnyObject?
                    let balanceTransaction : String?
                    let billingDetails : BillingDetail?
                    let captured : Bool?
                    let created : Int?
                    let currency : String?
                    let customer : String?
                    let descriptionField : String?
//                    let destination : AnyObject?
//                    let dispute : AnyObject?
                    let disputed : Bool?
//                    let failureCode : AnyObject?
//                    let failureMessage : AnyObject?
                    let id : String?
//                    let invoice : AnyObject?
                    let livemode : Bool?
                    let object : String?
//                    let onBehalfOf : AnyObject?
//                    let order : AnyObject?
                    let outcome : Outcome?
                    let paid : Bool?
//                    let paymentIntent : AnyObject?
                    let paymentMethod : String?
                    let paymentMethodDetails : PaymentMethodDetail?
//                    let receiptEmail : AnyObject?
//                    let receiptNumber : AnyObject?
                    let receiptUrl : String?
                    let refunded : Bool?
                    let refunds : Refund?
//                    let review : AnyObject?
//                    let shipping : AnyObject?
                    let source : Source?
//                    let sourceTransfer : AnyObject?
//                    let statementDescriptor : AnyObject?
//                    let statementDescriptorSuffix : AnyObject?
                    let status : String?
//                    let transferData : AnyObject?
//                    let transferGroup : AnyObject?

                    enum CodingKeys: String, CodingKey {
                            case amount = "amount"
                            case amountRefunded = "amount_refunded"
//                            case application = "application"
//                            case applicationFee = "application_fee"
//                            case applicationFeeAmount = "application_fee_amount"
                            case balanceTransaction = "balance_transaction"
                            case billingDetails = "billing_details"
                            case captured = "captured"
                            case created = "created"
                            case currency = "currency"
                            case customer = "customer"
                            case descriptionField = "description"
//                            case destination = "destination"
//                            case dispute = "dispute"
                            case disputed = "disputed"
//                            case failureCode = "failure_code"
//                            case failureMessage = "failure_message"
                            case id = "id"
//                            case invoice = "invoice"
                            case livemode = "livemode"
                            case object = "object"
//                            case onBehalfOf = "on_behalf_of"
//                            case order = "order"
                            case outcome = "outcome"
                            case paid = "paid"
//                            case paymentIntent = "payment_intent"
                            case paymentMethod = "payment_method"
                            case paymentMethodDetails = "payment_method_details"
//                            case receiptEmail = "receipt_email"
//                            case receiptNumber = "receipt_number"
                            case receiptUrl = "receipt_url"
                            case refunded = "refunded"
                            case refunds = "refunds"
//                            case review = "review"
//                            case shipping = "shipping"
                            case source = "source"
//                            case sourceTransfer = "source_transfer"
//                            case statementDescriptor = "statement_descriptor"
//                            case statementDescriptorSuffix = "statement_descriptor_suffix"
                            case status = "status"
//                            case transferData = "transfer_data"
//                            case transferGroup = "transfer_group"
                    }
                
                    init(from decoder: Decoder) throws {
                            let values = try decoder.container(keyedBy: CodingKeys.self)
                            amount = try values.decodeIfPresent(Int.self, forKey: .amount)
                            amountRefunded = try values.decodeIfPresent(Int.self, forKey: .amountRefunded)
//                            application = try values.decodeIfPresent(AnyObject.self, forKey: .application)
//                            applicationFee = try values.decodeIfPresent(AnyObject.self, forKey: .applicationFee)
//                            applicationFeeAmount = try values.decodeIfPresent(AnyObject.self, forKey: .applicationFeeAmount)
                            balanceTransaction = try values.decodeIfPresent(String.self, forKey: .balanceTransaction)
                            billingDetails = try values.decodeIfPresent(BillingDetail.self, forKey: .billingDetails)
                            captured = try values.decodeIfPresent(Bool.self, forKey: .captured)
                            created = try values.decodeIfPresent(Int.self, forKey: .created)
                            currency = try values.decodeIfPresent(String.self, forKey: .currency)
                            customer = try values.decodeIfPresent(String.self, forKey: .customer)
                            descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
//                            destination = try values.decodeIfPresent(AnyObject.self, forKey: .destination)
//                            dispute = try values.decodeIfPresent(AnyObject.self, forKey: .dispute)
                            disputed = try values.decodeIfPresent(Bool.self, forKey: .disputed)
//                            failureCode = try values.decodeIfPresent(AnyObject.self, forKey: .failureCode)
//                            failureMessage = try values.decodeIfPresent(AnyObject.self, forKey: .failureMessage)
                            id = try values.decodeIfPresent(String.self, forKey: .id)
//                            invoice = try values.decodeIfPresent(AnyObject.self, forKey: .invoice)
                            livemode = try values.decodeIfPresent(Bool.self, forKey: .livemode)
                            object = try values.decodeIfPresent(String.self, forKey: .object)
//                            onBehalfOf = try values.decodeIfPresent(AnyObject.self, forKey: .onBehalfOf)
//                            order = try values.decodeIfPresent(AnyObject.self, forKey: .order)
                            outcome = try values.decodeIfPresent(Outcome.self, forKey: .outcome)
                            paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
//                            paymentIntent = try values.decodeIfPresent(AnyObject.self, forKey: .paymentIntent)
                            paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
                            paymentMethodDetails = try values.decodeIfPresent(PaymentMethodDetail.self, forKey: .paymentMethodDetails)
//                            receiptEmail = try values.decodeIfPresent(AnyObject.self, forKey: .receiptEmail)
//                            receiptNumber = try values.decodeIfPresent(AnyObject.self, forKey: .receiptNumber)
                            receiptUrl = try values.decodeIfPresent(String.self, forKey: .receiptUrl)
                            refunded = try values.decodeIfPresent(Bool.self, forKey: .refunded)
                            refunds = try values.decodeIfPresent(Refund.self, forKey: .refunds)
//                            review = try values.decodeIfPresent(AnyObject.self, forKey: .review)
//                            shipping = try values.decodeIfPresent(AnyObject.self, forKey: .shipping)
                            source = try values.decodeIfPresent(Source.self, forKey: .source)
//                            sourceTransfer = try values.decodeIfPresent(AnyObject.self, forKey: .sourceTransfer)
//                            statementDescriptor = try values.decodeIfPresent(AnyObject.self, forKey: .statementDescriptor)
//                            statementDescriptorSuffix = try values.decodeIfPresent(AnyObject.self, forKey: .statementDescriptorSuffix)
                            status = try values.decodeIfPresent(String.self, forKey: .status)
//                            transferData = try values.decodeIfPresent(AnyObject.self, forKey: .transferData)
//                            transferGroup = try values.decodeIfPresent(AnyObject.self, forKey: .transferGroup)
                    }
                struct BillingDetail : Codable {

                        let address : Address?
                        let email : String?
                        let name : String?
                        let phone : String?

                        enum CodingKeys: String, CodingKey {
                                case address = "address"
                                case email = "email"
                                case name = "name"
                                case phone = "phone"
                        }
                    
                        init(from decoder: Decoder) throws {
                                let values = try decoder.container(keyedBy: CodingKeys.self)
                                address = try values.decodeIfPresent(Address.self, forKey: .address)
                                email = try values.decodeIfPresent(String.self, forKey: .email)
                                name = try values.decodeIfPresent(String.self, forKey: .name)
                                phone = try values.decodeIfPresent(String.self, forKey: .phone)
                        }
                    struct Address : Codable {

                            let city : String?
                            let country : String?
                            let line1 : String?
                            let line2 : String?
                            let postalCode : String?
                            let state : String?

                            enum CodingKeys: String, CodingKey {
                                    case city = "city"
                                    case country = "country"
                                    case line1 = "line1"
                                    case line2 = "line2"
                                    case postalCode = "postal_code"
                                    case state = "state"
                            }
                        
                            init(from decoder: Decoder) throws {
                                    let values = try decoder.container(keyedBy: CodingKeys.self)
                                    city = try values.decodeIfPresent(String.self, forKey: .city)
                                    country = try values.decodeIfPresent(String.self, forKey: .country)
                                    line1 = try values.decodeIfPresent(String.self, forKey: .line1)
                                    line2 = try values.decodeIfPresent(String.self, forKey: .line2)
                                    postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
                                    state = try values.decodeIfPresent(String.self, forKey: .state)
                            }

                    }
                }
                struct Outcome : Codable {

                        let networkStatus : String?
                        let reason : String?
                        let riskLevel : String?
                        let riskScore : Int?
                        let sellerMessage : String?
                        let type : String?

                        enum CodingKeys: String, CodingKey {
                                case networkStatus = "network_status"
                                case reason = "reason"
                                case riskLevel = "risk_level"
                                case riskScore = "risk_score"
                                case sellerMessage = "seller_message"
                                case type = "type"
                        }
                    
                        init(from decoder: Decoder) throws {
                                let values = try decoder.container(keyedBy: CodingKeys.self)
                                networkStatus = try values.decodeIfPresent(String.self, forKey: .networkStatus)
                                reason = try values.decodeIfPresent(String.self, forKey: .reason)
                                riskLevel = try values.decodeIfPresent(String.self, forKey: .riskLevel)
                                riskScore = try values.decodeIfPresent(Int.self, forKey: .riskScore)
                                sellerMessage = try values.decodeIfPresent(String.self, forKey: .sellerMessage)
                                type = try values.decodeIfPresent(String.self, forKey: .type)
                        }

                }

                struct Source : Codable {

                        let addressCity : String?
                        let addressCountry : String?
                        let addressLine1 : String?
                        let addressLine1Check : String?
                        let addressLine2 : String?
                        let addressState : String?
                        let addressZip : String?
                        let addressZipCheck : String?
                        let brand : String?
                        let country : String?
                        let customer : String?
                        let cvcCheck : String?
                        let dynamicLast4 : String?
                        let expMonth : Int?
                        let expYear : Int?
                        let fingerprint : String?
                        let funding : String?
                        let id : String?
                        let last4 : String?
                        let name : String?
                        let object : String?
                        let tokenizationMethod : String?

                        enum CodingKeys: String, CodingKey {
                                case addressCity = "address_city"
                                case addressCountry = "address_country"
                                case addressLine1 = "address_line1"
                                case addressLine1Check = "address_line1_check"
                                case addressLine2 = "address_line2"
                                case addressState = "address_state"
                                case addressZip = "address_zip"
                                case addressZipCheck = "address_zip_check"
                                case brand = "brand"
                                case country = "country"
                                case customer = "customer"
                                case cvcCheck = "cvc_check"
                                case dynamicLast4 = "dynamic_last4"
                                case expMonth = "exp_month"
                                case expYear = "exp_year"
                                case fingerprint = "fingerprint"
                                case funding = "funding"
                                case id = "id"
                                case last4 = "last4"
                                case name = "name"
                                case object = "object"
                                case tokenizationMethod = "tokenization_method"
                        }
                    
                        init(from decoder: Decoder) throws {
                                let values = try decoder.container(keyedBy: CodingKeys.self)
                                addressCity = try values.decodeIfPresent(String.self, forKey: .addressCity)
                                addressCountry = try values.decodeIfPresent(String.self, forKey: .addressCountry)
                                addressLine1 = try values.decodeIfPresent(String.self, forKey: .addressLine1)
                                addressLine1Check = try values.decodeIfPresent(String.self, forKey: .addressLine1Check)
                                addressLine2 = try values.decodeIfPresent(String.self, forKey: .addressLine2)
                                addressState = try values.decodeIfPresent(String.self, forKey: .addressState)
                                addressZip = try values.decodeIfPresent(String.self, forKey: .addressZip)
                                addressZipCheck = try values.decodeIfPresent(String.self, forKey: .addressZipCheck)
                                brand = try values.decodeIfPresent(String.self, forKey: .brand)
                                country = try values.decodeIfPresent(String.self, forKey: .country)
                                customer = try values.decodeIfPresent(String.self, forKey: .customer)
                                cvcCheck = try values.decodeIfPresent(String.self, forKey: .cvcCheck)
                                dynamicLast4 = try values.decodeIfPresent(String.self, forKey: .dynamicLast4)
                                expMonth = try values.decodeIfPresent(Int.self, forKey: .expMonth)
                                expYear = try values.decodeIfPresent(Int.self, forKey: .expYear)
                                fingerprint = try values.decodeIfPresent(String.self, forKey: .fingerprint)
                                funding = try values.decodeIfPresent(String.self, forKey: .funding)
                                id = try values.decodeIfPresent(String.self, forKey: .id)
                                last4 = try values.decodeIfPresent(String.self, forKey: .last4)
                                name = try values.decodeIfPresent(String.self, forKey: .name)
                                object = try values.decodeIfPresent(String.self, forKey: .object)
                                tokenizationMethod = try values.decodeIfPresent(String.self, forKey: .tokenizationMethod)
                        }

                }
                struct Refund : Codable {

//                        let data : [AnyObject]?
                        let hasMore : Bool?
                        let object : String?
                        let totalCount : Int?
                        let url : String?

                        enum CodingKeys: String, CodingKey {
//                                case data = "data"
                                case hasMore = "has_more"
                                case object = "object"
                                case totalCount = "total_count"
                                case url = "url"
                        }
                    
                        init(from decoder: Decoder) throws {
                                let values = try decoder.container(keyedBy: CodingKeys.self)
//                                data = try values.decodeIfPresent([AnyObject].self, forKey: .data)
                                hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore)
                                object = try values.decodeIfPresent(String.self, forKey: .object)
                                totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
                                url = try values.decodeIfPresent(String.self, forKey: .url)
                        }

                }
                struct PaymentMethodDetail : Codable {

                        let card : Card?
                        let type : String?

                        enum CodingKeys: String, CodingKey {
                                case card = "card"
                                case type = "type"
                        }
                    
                        init(from decoder: Decoder) throws {
                                let values = try decoder.container(keyedBy: CodingKeys.self)
                                card = try values.decodeIfPresent(Card.self, forKey: .card)
                                type = try values.decodeIfPresent(String.self, forKey: .type)
                        }
                    struct Card : Codable {

                            let brand : String?
//                            let checks : Check?
                            let country : String?
                            let expMonth : Int?
                            let expYear : Int?
                            let fingerprint : String?
                            let funding : String?
//                            let installments : AnyObject?
                            let last4 : String?
                            let network : String?
//                            let threeDSecure : AnyObject?
//                            let wallet : AnyObject?

                            enum CodingKeys: String, CodingKey {
                                    case brand = "brand"
//                                    case checks = "checks"
                                    case country = "country"
                                    case expMonth = "exp_month"
                                    case expYear = "exp_year"
                                    case fingerprint = "fingerprint"
                                    case funding = "funding"
//                                    case installments = "installments"
                                    case last4 = "last4"
                                    case network = "network"
//                                    case threeDSecure = "three_d_secure"
//                                    case wallet = "wallet"
                            }
                        
                            init(from decoder: Decoder) throws {
                                    let values = try decoder.container(keyedBy: CodingKeys.self)
                                    brand = try values.decodeIfPresent(String.self, forKey: .brand)
//                                    checks = try values.decodeIfPresent(Check.self, forKey: .checks)
                                    country = try values.decodeIfPresent(String.self, forKey: .country)
                                    expMonth = try values.decodeIfPresent(Int.self, forKey: .expMonth)
                                    expYear = try values.decodeIfPresent(Int.self, forKey: .expYear)
                                    fingerprint = try values.decodeIfPresent(String.self, forKey: .fingerprint)
                                    funding = try values.decodeIfPresent(String.self, forKey: .funding)
//                                    installments = try values.decodeIfPresent(AnyObject.self, forKey: .installments)
                                    last4 = try values.decodeIfPresent(String.self, forKey: .last4)
                                    network = try values.decodeIfPresent(String.self, forKey: .network)
//                                    threeDSecure = try values.decodeIfPresent(AnyObject.self, forKey: .threeDSecure)
//                                    wallet = try values.decodeIfPresent(AnyObject.self, forKey: .wallet)
                            }
                        /*
                        struct Check : Codable {

                                let addressLine1Check : AnyObject?
                                let addressPostalCodeCheck : AnyObject?
                                let cvcCheck : AnyObject?

                                enum CodingKeys: String, CodingKey {
                                        case addressLine1Check = "address_line1_check"
                                        case addressPostalCodeCheck = "address_postal_code_check"
                                        case cvcCheck = "cvc_check"
                                }
                            
                                init(from decoder: Decoder) throws {
                                        let values = try decoder.container(keyedBy: CodingKeys.self)
                                        addressLine1Check = try values.decodeIfPresent(AnyObject.self, forKey: .addressLine1Check)
                                        addressPostalCodeCheck = try values.decodeIfPresent(AnyObject.self, forKey: .addressPostalCodeCheck)
                                        cvcCheck = try values.decodeIfPresent(AnyObject.self, forKey: .cvcCheck)
                                }

                        }
                        */

                    }

                }

            }
        }
    }

}
