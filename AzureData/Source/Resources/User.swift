//
//  User.swift
//  AzureData
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Represents a user in the Azure Cosmos DB service.
public struct User : CodableResource {
    
    public static var type = "users"
    public static var list = "Users"

    public private(set) var id:             String
    public private(set) var resourceId:     String
    public private(set) var selfLink:       String?
    public private(set) var etag:           String?
    public private(set) var timestamp:      Date?
    
    /// Gets the self-link of the permissions associated with the user for the Azure Cosmos DB service.
    public private(set) var permissionsLink:String?
}


private extension User {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case permissionsLink    = "_permissions"
    }
}
