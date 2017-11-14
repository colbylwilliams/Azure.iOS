//
//  DocumentCollection.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct DocumentCollection : CodableResource {
    
    public static var type = "colls"
    public static var list = "DocumentCollections"
    
    public static func parentPath (_ parentIds: String...) -> String {
        return "\(Database.type)/\(parentIds[0])"
    }
    
    public private(set) var id:                         String
    public private(set) var resourceId:                 String
    public private(set) var selfLink:                   String?
    public private(set) var etag:                       String?
    public private(set) var timestamp:                  Date?
    public private(set) var conflictsLink:              String?
    public private(set) var documentsLink:              String?
    public private(set) var indexingPolicy:             IndexingPolicy?
    public private(set) var partitionKey:               PartitionKeyDefinition?
    public private(set) var storedProceduresLink:       String?
    public private(set) var triggersLink:               String?
    public private(set) var userDefinedFunctionsLink:   String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resourceId                 = "_rid"
        case selfLink                   = "_self"
        case etag                       = "_etag"
        case timestamp                  = "_ts"
        case conflictsLink              = "_conflicts"
        case documentsLink              = "_docs"
        case indexingPolicy
        case partitionKey
        case storedProceduresLink       = "_sprocs"
        case triggersLink               = "_triggers"
        case userDefinedFunctionsLink   = "_udfs"
    }
    
    public init (_ id: String) { self.id = id; resourceId = "" }
    
    public struct IndexingPolicy : Codable {
        
        public private(set) var automatic:      Bool?
        public private(set) var excludedPaths:  [ExcludedPath] = []
        public private(set) var includedPaths:  [IncludedPath] = []
        public private(set) var indexingMode:   IndexMode?
        
        public struct ExcludedPath : Codable {
            public private(set) var path: String?
        }
        
        public struct IncludedPath : Codable {
            
            public private(set) var path: String?
            public private(set) var indexes: [Index] = []
            
            public struct Index : Codable {
                public private(set) var kind:       IndexKind?
                public private(set) var dataType:   DataType?
                public private(set) var precision:  Int16?
                
                public enum IndexKind: String, Codable {
                    case hash       = "Hash"
                    case range      = "Range"
                    case spatial    = "Spatial"
                }
                
                public enum DataType: String, Codable {
                    case lineString = "LineString"
                    case number     = "Number"
                    case point      = "Point"
                    case polygon    = "Polygon"
                    case string     = "String"
                }
            }
        }
        
        public enum IndexMode: String, Codable {
            case consistent = "consistent"
            case lazy       = "lazy"
            case none       = "none"
        }
    }
    
    public struct PartitionKeyDefinition : Codable {
        public private(set) var paths: [String] = []
    }
    
    public func childLink (_ resourceId: String? = nil) -> String {
        return resourceId.isNilOrEmpty ? String(selfLink!.split(separator: "/").last!).lowercased() : resourceId!.lowercased()
    }
}
