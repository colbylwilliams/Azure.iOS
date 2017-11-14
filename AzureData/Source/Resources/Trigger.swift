//
//  Trigger.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Trigger : CodableResource {
    
    public static var type = "triggers"
    public static var list = "Triggers"

    public private(set) var id:                 String
    public private(set) var resourceId:         String
    public private(set) var selfLink:           String?
    public private(set) var etag:               String?
    public private(set) var timestamp:          Date?
    public private(set) var body:               String?
    public private(set) var triggerOperation:   TriggerOperation?
    public private(set) var triggerType:        TriggerType?


    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case body
        case triggerOperation
        case triggerType
    }

    public enum TriggerOperation: String, Codable {
        case all        = "All"
        case insert     = "Insert"
        case replace    = "Replace"
        case delete     = "Delete"
    }
    
    public enum TriggerType: String, Codable {
        case pre  = "Pre"
        case post = "Post"
    }
}
