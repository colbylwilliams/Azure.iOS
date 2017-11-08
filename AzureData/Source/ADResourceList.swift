//
//  ADResourceList.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADResourceList<T:ADResource> {
    
    let resourceIdKey   = "_rid"
    let countKey        = "_count"
    
    public private(set) var resourceId: String
    public private(set) var count:      Int
    public private(set) var items:[T]   = []
    
    init?(_ resourceType: String, json dict: [String:Any]) {
        if let resourceId   = dict[resourceIdKey]   as? String { self.resourceId = resourceId } else { return nil }
        count       = dict[countKey]        as? Int ?? 0
        if let resourceDicts = dict[resourceType] as? [[String:Any]] {
            for resourceDict in resourceDicts {
                if let resource = T(fromJson: resourceDict) {
                    self.items.append(resource)
                }
            }
        }
    }
    
    convenience init?(_ resourceType: ADResourceType, json dict: [String:Any]) {
        self.init(resourceType.key, json: dict)
    }
}
