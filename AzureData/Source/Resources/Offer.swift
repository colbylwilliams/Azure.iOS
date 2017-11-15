//
//  Offer.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Offer : CodableResource {
    
    public static var type = "offers"
    public static var list = "Offers"
    
    public var _altLink: String? = nil
    
    public private(set) var id:             String
    public private(set) var resourceId:     String
    public private(set) var selfLink:       String?
    public private(set) var etag:           String?
    public private(set) var timestamp:      Date?
    public private(set) var offerType:      String?
    public private(set) var offerVersion:   String?
    public private(set) var resourceLink:   String?
    public private(set) var offerResourceId:String?
    public private(set) var content:        OfferContent?

    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case offerType
        case offerVersion
        case resourceLink       = "resource"
        case offerResourceId
        case content
    }

    public struct OfferContent : Codable {
        public private(set) var offerThroughput: Int = 1000
        public private(set) var offerIsRUPerMinuteThroughputEnabled: Bool?
    }
}
