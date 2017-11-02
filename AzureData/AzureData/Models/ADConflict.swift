//
//  ADConflict.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADConflict: ADResource {
    
    let operationKindKey    = "operationKind"
    let resourceTypeKey     = "resourceType"
    let sourceResourceIdKey = "sourceResourceId"
    
    public private(set) var operationKind:   String?
    public private(set) var resourceType:    String?
    public private(set) var sourceResourceId:String?

    required public init?(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)
        
        operationKind = dict[operationKindKey] as? String
        resourceType = dict[resourceTypeKey] as? String
        sourceResourceId = dict[sourceResourceIdKey] as? String
    }
}
