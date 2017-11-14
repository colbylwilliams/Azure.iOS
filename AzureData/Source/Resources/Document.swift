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


//extension Array : Equatable where Element : Equatable { }
//
//
//extension Dictionary where Value : Encodable, self : Encodable {
//    public func encode(to encoder: Encoder) throws {
//
//    }
//}

/*

/// A wrapper for dictionary keys which are Strings or Ints.
@_versioned // FIXME(sil-serialize-all)
@_fixed_layout // FIXME(sil-serialize-all)
internal struct _DictionaryCodingKey : CodingKey {
    @_versioned // FIXME(sil-serialize-all)
    internal let stringValue: String
    @_versioned // FIXME(sil-serialize-all)
    internal let intValue: Int?
    
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }
    
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}



@_inlineable // FIXME(sil-serialize-all)
@_versioned // FIXME(sil-serialize-all)
internal func assertTypeIsEncodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Encodable.Type else {
        if T.self == Encodable.self || T.self == Codable.self {
            preconditionFailure("\(wrappingType) does not conform to Encodable because Encodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Encodable because \(T.self) does not conform to Encodable.")
        }
    }
}

@_inlineable // FIXME(sil-serialize-all)
@_versioned // FIXME(sil-serialize-all)
internal func assertTypeIsDecodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Decodable.Type else {
        if T.self == Decodable.self || T.self == Codable.self {
            preconditionFailure("\(wrappingType) does not conform to Decodable because Decodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Decodable because \(T.self) does not conform to Decodable.")
        }
    }
}

// FIXME: Remove when conditional conformance is available.
extension Encodable {
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal func __encode(to container: inout SingleValueEncodingContainer) throws { try container.encode(self) }
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal func __encode(to container: inout UnkeyedEncodingContainer)     throws { try container.encode(self) }
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal func __encode<Key>(to container: inout KeyedEncodingContainer<Key>, forKey key: Key) throws { try container.encode(self, forKey: key) }
}

// FIXME: Remove when conditional conformance is available.
extension Decodable {
    // Since we cannot call these __init, we'll give the parameter a '__'.
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal init(__from container: SingleValueDecodingContainer)   throws { self = try container.decode(Self.self) }
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal init(__from container: inout UnkeyedDecodingContainer) throws { self = try container.decode(Self.self) }
    @_inlineable // FIXME(sil-serialize-all)
    @_versioned // FIXME(sil-serialize-all)
    internal init<Key>(__from container: KeyedDecodingContainer<Key>, forKey key: Key) throws { self = try container.decode(Self.self, forKey: key) }
}

// FIXME: Uncomment when conditional conformance is available.
extension Optional : Encodable /* where Wrapped : Encodable */ {
    @_inlineable // FIXME(sil-serialize-all)
    public func encode(to encoder: Encoder) throws {
        assertTypeIsEncodable(Wrapped.self, in: type(of: self))
        
        var container = encoder.singleValueContainer()
        switch self {
        case .none: try container.encodeNil()
        case .some(let wrapped): try (wrapped as! Encodable).__encode(to: &container)
        }
    }
}

extension Optional : Decodable /* where Wrapped : Decodable */ {
    @_inlineable // FIXME(sil-serialize-all)
    public init(from decoder: Decoder) throws {
        // Initialize self here so we can get type(of: self).
        self = .none
        assertTypeIsDecodable(Wrapped.self, in: type(of: self))
        
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            let metaType = (Wrapped.self as! Decodable.Type)
            let element = try metaType.init(__from: container)
            self = .some(element as! Wrapped)
        }
    }
}


extension Dictionary : Encodable /* where Key : Encodable, Value : Encodable */ {
    @_inlineable // FIXME(sil-serialize-all)
    public func encode(to encoder: Encoder) throws {
        assertTypeIsEncodable(Key.self, in: type(of: self))
        assertTypeIsEncodable(Value.self, in: type(of: self))
        
        if Key.self == String.self {
            // Since the keys are already Strings, we can use them as keys directly.
            var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
            for (key, value) in self {
                let codingKey = _DictionaryCodingKey(stringValue: key as! String)!
                try (value as! Encodable).__encode(to: &container, forKey: codingKey)
            }
        } else if Key.self == Int.self {
            // Since the keys are already Ints, we can use them as keys directly.
            var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
            for (key, value) in self {
                let codingKey = _DictionaryCodingKey(intValue: key as! Int)!
                try (value as! Encodable).__encode(to: &container, forKey: codingKey)
            }
        } else {
            // Keys are Encodable but not Strings or Ints, so we cannot arbitrarily convert to keys.
            // We can encode as an array of alternating key-value pairs, though.
            var container = encoder.unkeyedContainer()
            for (key, value) in self {
                try (key as! Encodable).__encode(to: &container)
                try (value as! Encodable).__encode(to: &container)
            }
        }
    }
}

extension Dictionary : Decodable /* where Key : Decodable, Value : Decodable */ {
    @_inlineable // FIXME(sil-serialize-all)
    public init(from decoder: Decoder) throws {
        // Initialize self here so we can print type(of: self).
        self.init()
        assertTypeIsDecodable(Key.self, in: type(of: self))
        assertTypeIsDecodable(Value.self, in: type(of: self))
        
        if Key.self == String.self {
            // The keys are Strings, so we should be able to expect a keyed container.
            let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
            let valueMetaType = Value.self as! Decodable.Type
            for key in container.allKeys {
                let value = try valueMetaType.init(__from: container, forKey: key)
                self[key.stringValue as! Key] = (value as! Value)
            }
        } else if Key.self == Int.self {
            // The keys are Ints, so we should be able to expect a keyed container.
            let valueMetaType = Value.self as! Decodable.Type
            let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
            for key in container.allKeys {
                guard key.intValue != nil else {
                    // We provide stringValues for Int keys; if an encoder chooses not to use the actual intValues, we've encoded string keys.
                    // So on init, _DictionaryCodingKey tries to parse string keys as Ints. If that succeeds, then we would have had an intValue here.
                    // We don't, so this isn't a valid Int key.
                    var codingPath = decoder.codingPath
                    codingPath.append(key)
                    throw DecodingError.typeMismatch(Int.self,
                                                     DecodingError.Context(codingPath: codingPath,
                                                                           debugDescription: "Expected Int key but found String key instead."))
                }
                
                let value = try valueMetaType.init(__from: container, forKey: key)
                self[key.intValue! as! Key] = (value as! Value)
            }
        } else {
            // We should have encoded as an array of alternating key-value pairs.
            var container = try decoder.unkeyedContainer()
            
            // We're expecting to get pairs. If the container has a known count, it had better be even; no point in doing work if not.
            if let count = container.count {
                guard count % 2 == 0 else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                            debugDescription: "Expected collection of key-value pairs; encountered odd-length array instead."))
                }
            }
            
            let keyMetaType = (Key.self as! Decodable.Type)
            let valueMetaType = (Value.self as! Decodable.Type)
            while !container.isAtEnd {
                let key = try keyMetaType.init(__from: &container)
                
                guard !container.isAtEnd else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                            debugDescription: "Unkeyed container reached end before value in key-value pair."))
                }
                
                let value = try valueMetaType.init(__from: &container)
                self[key as! Key] = (value as! Value)
            }
        }
    }
}


*/
