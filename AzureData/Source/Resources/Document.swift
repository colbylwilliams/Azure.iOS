//
//  Document.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class Document : CodableResource {
    
    let sysKeys = ["id", "_rid", "_self", "_etag", "_ts", "_attachments"]

    public static var type = "docs"
    public static var list = "Documents"
    
    public static func parentPath (_ parentIds: String...) -> String {
        return "\(Database.type)/\(parentIds[0])/\(DocumentCollection.type)/\(parentIds[2])"
    }
    
    public var _altLink: String? = nil
    
    public private(set) var id:             String
    public private(set) var resourceId:     String
    public private(set) var selfLink:       String?
    public private(set) var etag:           String?
    public private(set) var timestamp:      Date?
    public private(set) var attachmentsLink:String?
    
    public private(set) var data: CodableDictionary?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId         = "_rid"
        case selfLink           = "_self"
        case etag               = "_etag"
        case timestamp          = "_ts"
        case attachmentsLink    = "_attachments"
        case data
    }
    
    public init () { id = UUID().uuidString; resourceId = "" }
    public init (_ id: String) { self.id = id; resourceId = "" }
    
//    public required init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        print(container.allKeys)
//
//        self.id = try container.decode(String.self, forKey: .id)
//        self.resourceId = try container.decode(String.self, forKey: .resourceId)
//        self.selfLink = try container.decodeIfPresent(String.self, forKey: .selfLink)//(String.self, forKey: .selfLink)
//        self.etag = try container.decode(String.self, forKey: .etag)
//        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
//        self.attachmentsLink = try container.decode(String.self, forKey: .attachmentsLink)
//        self.data = try container.decode(CodableDictionary.self, forKey: .data)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(resourceId, forKey: .resourceId)
//        try container.encode(selfLink, forKey: .selfLink)
//        try container.encode(etag, forKey: .etag)
//        try container.encode(timestamp, forKey: .timestamp)
//        try container.encode(attachmentsLink, forKey: .attachmentsLink)
//        try container.encode(data, forKey: .data)
//    }
    
    public subscript (key: String) -> Any? {
        get {
            return data?[key]
        }
        set {            
            assert(!sysKeys.contains(key), "Error: Subscript cannot be used to set the following system generated properties: \(sysKeys.joined(separator: ", "))\n")
            
            if data == nil { data = CodableDictionary() }
            
            data![key] = newValue
        }
    }
}

extension Document : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Document :\n\tid : \(self.id)\n\tresourceId : \(self.resourceId)\n\tselfLink : \(self.selfLink.valueOrNilString)\n\tetag : \(self.etag.valueOrNilString)\n\ttimestamp : \(self.timestamp.valueOrNilString)\n\tattachmentsLink : \(self.attachmentsLink.valueOrNilString)\n\tdata : \n\t\t\(self.data?.dictionary.map { "\($0) : \($1 ?? "nil")" }.joined(separator: "\n\t\t") ?? "nil")\n--"
    }
}
