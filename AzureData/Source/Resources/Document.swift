//
//  Document.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

/// Represents a document in the Azure Cosmos DB service.
///
/// - Remark:
///   A document is a structured JSON document. There is no set schema for the JSON documents,
///   and a document may contain any number of custom properties as well as an optional list of attachments.
///   Document is an application resource and can be authorized using the master key or resource keys.
open class Document : CodableResource, CustomDebugStringConvertible {
    
//    let sysKeys = ["id", "_rid", "_self", "_etag", "_ts", "_attachments"]

    public static var type = "docs"
    public static var list = "Documents"
    
    public private(set) var id:         String
    public private(set) var resourceId: String
    public private(set) var selfLink:   String?
    public private(set) var etag:       String?
    public private(set) var timestamp:  Date?
    
    
    /// Gets the self-link corresponding to attachments of the document from the Azure Cosmos DB service.
    public private(set) var attachmentsLink: String?
    
    /// Gets or sets the time to live in seconds of the document in the Azure Cosmos DB service.
    public var timeToLive: Int? = nil
    
    
    public init () { id = UUID().uuidString; resourceId = "" }
    public init (_ id: String) { self.id = id; resourceId = "" }
    
    
//    public required init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        id              = try container.decode(String.self, forKey: .id)
//        resourceId      = try container.decode(String.self, forKey: .resourceId)
//        selfLink        = try container.decode(String.self, forKey: .selfLink)
//        etag            = try container.decode(String.self, forKey: .etag)
//        timestamp       = try container.decode(Date.self,   forKey: .timestamp)
//        attachmentsLink = try container.decode(String.self, forKey: .attachmentsLink)
//    }
//
//
//    open func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(resourceId, forKey: .resourceId)
//        try container.encode(selfLink, forKey: .selfLink)
//        try container.encode(etag, forKey: .etag)
//        try container.encode(timestamp, forKey: .timestamp)
//        try container.encode(attachmentsLink, forKey: .attachmentsLink)
//    }
    
    public var debugDescription: String {
        return "Document :\n\tid : \(self.id)\n\tresourceId : \(self.resourceId)\n\tselfLink : \(self.selfLink.valueOrNilString)\n\tetag : \(self.etag.valueOrNilString)\n\ttimestamp : \(self.timestamp.valueOrNilString)\n\tattachmentsLink : \(self.attachmentsLink.valueOrNilString)\n--"
    }
}


private extension Document {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case attachmentsLink    = "_attachments"
    }
}

public extension Document {
    
    public static var testDocument: Document {
        let document = Document()
        document.resourceId = "TC1AAMDvwgB4AAAAAAAAAA=="
        document.selfLink = "dbs/TC1AAA==/colls/TC1AAMDvwgA=/docs/TC1AAMDvwgB4AAAAAAAAAA==/"
        document.etag = "\"88005b65-0000-0000-0000-5a0dfabb0000\""
        document.attachmentsLink = "attachments/"
        document.timestamp = Date(timeIntervalSince1970: 1510865595)
        return document
    }
}

