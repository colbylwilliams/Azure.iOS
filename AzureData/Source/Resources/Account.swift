//
//  Account.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Account : CodableResource {
    
    public static var type = "account"
    public static var list = "Accounts"
    
    public private(set) var id:                         String
    public private(set) var resourceId:                 String
    public private(set) var selfLink:                   String?
    public private(set) var etag:                       String?
    public private(set) var timestamp:                  Date?
    public private(set) var consistencyPolicy:          String?
    public private(set) var databasesLink:              String?
    public private(set) var maxMediaStorageUsageInMB:   String?
    public private(set) var mediaLink:                  String?
    public private(set) var mediaStorageUsageInMB:      String?
    public private(set) var readableLocations:          String?
    public private(set) var writableLocation:           String?
}


private extension Account {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case consistencyPolicy
        case databasesLink
        case maxMediaStorageUsageInMB
        case mediaLink
        case mediaStorageUsageInMB
        case readableLocations
        case writableLocation
    }
}
