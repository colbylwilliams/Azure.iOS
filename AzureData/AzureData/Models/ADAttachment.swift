//
//  ADAttachment.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADAttachment: ADResource {
    
    static let contentTypeKey   = "contentType"
    static let mediaLinkKey     = "media"

    public private(set) var contentType:String?
    public private(set) var mediaLink:  String?

    required public init?(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)
        
        contentType = dict[ADAttachment.contentTypeKey] as? String
        mediaLink = dict[ADAttachment.mediaLinkKey] as? String
    }
    
    public static func jsonDict(_ id: String, contentType: String, media: URL) -> [String:Any] {
        return [
            idKey:id,
            contentTypeKey:contentType,
            mediaLinkKey:media
        ]
    }
}
