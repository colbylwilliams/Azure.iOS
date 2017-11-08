//
//  ADTrigger.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADTrigger: ADResource {

    static let bodyKey              = "body"
    static let triggerOperationKey  = "triggerOperation"
    static let triggerTypeKey       = "triggerType"

    public private(set) var body:               String?
    public private(set) var triggerOperation:   ADTriggerOperation?
    public private(set) var triggerType:        ADTriggerType?

    required public init?(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)

        body = dict[ADTrigger.bodyKey] as? String
        if let triggerOperation = dict[ADTrigger.triggerOperationKey] as? String { self.triggerOperation = ADTriggerOperation(rawValue: triggerOperation)}
        if let triggerType = dict[ADTrigger.triggerTypeKey] as? String { self.triggerType = ADTriggerType(rawValue: triggerType)}
    }
    
    public static func jsonDict(_ id: String, body: String, operation: ADTriggerOperation, type: ADTriggerType) -> [String: Any] {
        return [
            idKey:id,
            bodyKey:body,
            triggerOperationKey:operation.rawValue,
            triggerTypeKey:type.rawValue
        ]
    }
}


public enum ADTriggerOperation: String {
    case all        = "All"
    case insert     = "Insert"
    case replace    = "Replace"
    case delete     = "Delete"
}


public enum ADTriggerType: String {
    case pre  = "Pre"
    case post = "Post"
}
