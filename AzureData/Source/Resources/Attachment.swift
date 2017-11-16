//
//  Attachment.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Attachment : CodableResource {
    
    public static var type = "attachments"
    public static var list = "Attachments"
    
    public private(set) var id:         String
    public private(set) var resourceId: String
    public private(set) var selfLink:   String?
    public private(set) var etag:       String?
    public private(set) var timestamp:  Date?
    public private(set) var contentType:String?
    public private(set) var mediaLink:  String?

    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case contentType
        case mediaLink          = "media"
    }
    
    init(withId id: String, contentType: String, url: String) {
        self.id = id
        self.resourceId = ""
        self.contentType = contentType
        self.mediaLink = url
    }
}
