//
//  DictionaryDocument.swift
//  AzureData
//
//  Created by Colby L Williams on 1/3/18.
//  Copyright © 2018 Colby Williams. All rights reserved.
//

import Foundation

/// Represents a document in the Azure Cosmos DB service.
///
/// - Remark:
///   A document is a structured JSON document. There is no set schema for the JSON documents,
///   and a document may contain any number of custom properties as well as an optional list of attachments.
///   Document is an application resource and can be authorized using the master key or resource keys.
public class DictionaryDocument : Document {
    
    let sysKeys = ["id", "_rid", "_self", "_etag", "_ts", "_attachments"]
    
    //public static var type = "docs"
    //public static var list = "Documents"
    
//    public private(set) var id:         String
//    public private(set) var resourceId: String
//    public private(set) var selfLink:   String?
//    public private(set) var etag:       String?
//    public private(set) var timestamp:  Date?
    
    
    /// Gets the self-link corresponding to attachments of the document from the Azure Cosmos DB service.
//    public private(set) var attachmentsLink: String?
    
    /// Gets or sets the time to live in seconds of the document in the Azure Cosmos DB service.
//    public var timeToLive: Int? = nil
    
    
    public private(set) var data: CodableDictionary?
    
    
    public override init () { super.init() }
    public override init (_ id: String) { super.init(id) }
    
    
    public subscript (key: String) -> Any? {
        get { return data?[key] }
        set {
            assert(Swift.type(of: self) == DictionaryDocument.self, "Error: Subscript cannot be used on children of DictionaryDocument\n")
            assert(!sysKeys.contains(key), "Error: Subscript cannot be used to set the following system generated properties: \(sysKeys.joined(separator: ", "))\n")
            
            if data == nil { data = CodableDictionary() }
            
            data![key] = newValue
        }
    }
    
//    private enum SysCodingKeys: String, CodingKey {
//        case id
//        case resourceId         = "_rid"
//        case selfLink           = "_self"
//        case etag               = "_etag"
//        case timestamp          = "_ts"
//        case attachmentsLink    = "_attachments"
//    }
    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
//        let sysContainer = try decoder.container(keyedBy: SysCodingKeys.self)
//
//        id              = try sysContainer.decode(String.self, forKey: .id)
//        resourceId      = try sysContainer.decode(String.self, forKey: .resourceId)
//        selfLink        = try sysContainer.decode(String.self, forKey: .selfLink)
//        etag            = try sysContainer.decode(String.self, forKey: .etag)
//        timestamp       = try sysContainer.decode(Date.self,   forKey: .timestamp)
//        attachmentsLink = try sysContainer.decode(String.self, forKey: .attachmentsLink)
        
        if Swift.type(of: self) == DictionaryDocument.self {
            
            let userContainer = try decoder.container(keyedBy: UserCodingKeys.self)
            
            data = CodableDictionary()
            
            let userKeys = userContainer.allKeys.filter { !sysKeys.contains($0.stringValue) }
            
            for key in userKeys {
                data![key.stringValue] = (try? userContainer.decode(CodableDictionaryValueType.self, forKey: key))?.value
            }
        }
    }
    
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
//        var sysContainer = encoder.container(keyedBy: SysCodingKeys.self)
//
//        try sysContainer.encode(id, forKey: .id)
//        try sysContainer.encode(resourceId, forKey: .resourceId)
//        try sysContainer.encode(selfLink, forKey: .selfLink)
//        try sysContainer.encode(etag, forKey: .etag)
//        try sysContainer.encode(timestamp, forKey: .timestamp)
//        try sysContainer.encode(attachmentsLink, forKey: .attachmentsLink)
        
        if Swift.type(of: self) == DictionaryDocument.self {
            
            var userContainer = encoder.container(keyedBy: UserCodingKeys.self)
            
            if let data = data {
                
                for (k, v) in data {
                    
                    let key = UserCodingKeys(stringValue: k)!
                    
                    switch v {
                    case .uuid(let value): try userContainer.encode(value, forKey: key)
                    case .bool(let value): try userContainer.encode(value, forKey: key)
                    case .int(let value): try userContainer.encode(value, forKey: key)
                    case .double(let value): try userContainer.encode(value, forKey: key)
                    case .float(let value): try userContainer.encode(value, forKey: key)
                    case .date(let value): try userContainer.encode(value, forKey: key)
                    case .string(let value): try userContainer.encode(value, forKey: key)
                    case .dictionary(let value): try userContainer.encode(value, forKey: key)
                    case .array(let value): try userContainer.encode(value, forKey: key)
                    default: break
                    }
                }
            }
        }
    }
    
    private struct UserCodingKeys : CodingKey {
        
        let key: String
        
        var stringValue: String {
            return key
        }
        
        init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? { return nil }
        
        
        init?(intValue: Int) { return nil }
    }
    
    public override var debugDescription: String {
        return "DictionaryDocument :\n\tid : \(self.id)\n\tresourceId : \(self.resourceId)\n\tselfLink : \(self.selfLink.valueOrNilString)\n\tetag : \(self.etag.valueOrNilString)\n\ttimestamp : \(self.timestamp.valueOrNilString)\n\tattachmentsLink : \(self.attachmentsLink.valueOrNilString)\n\t\(self.data?.dictionary.map { "\($0) : \($1 ?? "nil")" }.joined(separator: "\n\t") ?? "nil")\n--"
    }
}
