//
//  ADPermission.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADPermission: ADResource {

    let permissionModeKey       = "permissionMode"
    let resourceLinkKey         = "resourceLink"
    let resourcePartitionKeyKey = "resourcePartitionKey"
    let tokenKey                = "token"

    public private(set) var permissionMode:         ADPermissionMode?
    public private(set) var resourceLink:           String?
    public private(set) var resourcePartitionKey:   String?
    public private(set) var token:                  String?

    required public init?(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)

        if let permissionMode = dict[permissionModeKey] as? String { self.permissionMode = ADPermissionMode(rawValue: permissionMode)}
        resourceLink = dict[resourceLinkKey] as? String
        resourcePartitionKey = dict[resourcePartitionKeyKey] as? String
        token = dict[tokenKey] as? String
    }
}

public enum ADPermissionMode: String {
    case read   = "Read"
    case all    = "All"
}