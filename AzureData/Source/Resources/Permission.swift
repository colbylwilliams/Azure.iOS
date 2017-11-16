//
//  Permission.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Permission : CodableResource {
    
    public static var type = "permissions"
    public static var list = "Permissions"

    public private(set) var id:                     String
    public private(set) var resourceId:             String
    public private(set) var selfLink:               String?
    public private(set) var etag:                   String?
    public private(set) var timestamp:              Date?
    public private(set) var permissionMode:         PermissionMode?
    public private(set) var resourceLink:           String?
    public private(set) var resourcePartitionKey:   String?
    public private(set) var token:                  String?

    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case permissionMode
        case resourceLink
        case resourcePartitionKey
        case token
    }

    public enum PermissionMode: String, Codable {
        case read   = "Read"
        case all    = "All"
    }
    
    init(withId id: String, mode: PermissionMode, forResource resource: String) {
        self.id = id
        self.resourceId = ""
        self.permissionMode = mode
        self.resourceLink = resource
    }
}
