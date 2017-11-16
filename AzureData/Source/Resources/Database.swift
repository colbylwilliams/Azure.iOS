//
//  Database.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Database : CodableResource {
    
    public static var type = "dbs"
    public static var list = "Databases"

    public private(set) var id:             String
    public private(set) var resourceId:     String
    public private(set) var selfLink:       String?
    public private(set) var etag:           String?
    public private(set) var timestamp:      Date?
    public private(set) var collectionsLink:String?
    public private(set) var usersLink:      String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case collectionsLink    = "_colls"
        case usersLink          = "_users"
    }
    
    public init (_ id: String) { self.id = id; resourceId = "" }
}

extension Database : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Database :\n\tid : \(self.id)\n\tresourceId : \(self.resourceId)\n\tselfLink : \(self.selfLink.valueOrNilString)\n\tetag : \(self.etag.valueOrNilString)\n\ttimestamp : \(self.timestamp.valueOrNilString)\n\tcollectionsLink : \(self.collectionsLink.valueOrNilString)\n\tusersLink : \(self.usersLink.valueOrNilString)\n--"
    }
}
