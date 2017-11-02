//
//  ADIndexingPolicy.swift
//  AzureData
//
//  Created by Colby Williams on 10/20/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADIndexingPolicy {
    
    let automaticKey        = "automatic"
    let excludedPathsKey    = "excludedPaths"
    let includedPathsKey    = "includedPaths"
    let indexingModeKey     = "indexingMode"
    
    public private(set) var automatic:      Bool?
    public private(set) var excludedPaths:  [ADExcludedPath] = []
    public private(set) var includedPaths:  [ADIncludedPath] = []
    public private(set) var indexingMode:   ADIndexMode?
    
    public init(fromJson dict: [String:Any]) {
        if let automatic        = dict[automaticKey]     as? Bool { self.automatic = automatic }
        if let excludedPaths    = dict[excludedPathsKey] as? [[String:Any]] {
            for path in excludedPaths {
                self.excludedPaths.append(ADExcludedPath(fromJson: path))
            }
        }
        if let includedPaths    = dict[includedPathsKey] as? [[String:Any]] {
            for path in includedPaths {
                self.includedPaths.append(ADIncludedPath(fromJson: path))
            }
        }
        if let indexingModeRaw  = dict[indexingModeKey]  as? String, let indexingMode = ADIndexMode(rawValue: indexingModeRaw) { self.indexingMode = indexingMode }
    }
    
    public var dictionary: [String : Any] {
        return [
            automaticKey:automatic ?? "",
            excludedPathsKey:excludedPaths.map{ $0.dictionary },
            includedPathsKey:includedPaths.map{ $0.dictionary },
            indexingModeKey:indexingMode?.rawValue ?? ""
        ]
    }
}


public class ADPath {
    
    let pathKey = "path"
    
    public private(set) var path: String?

    public init(fromJson dict: [String:Any]) {
        path = dict[pathKey] as? String
    }
    
    public var dictionary: [String : Any] {
        return [ pathKey:path ?? "" ]
    }
}


public class ADExcludedPath: ADPath { }


public class ADIncludedPath: ADPath {
    
    let indexesKey = "indexes"
    
    public private(set) var indexes: [ADIndex] = []

    public override init(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)
        if let indexes = dict[indexesKey] as? [[String:Any]] { 
            for index in indexes {
                self.indexes.append(ADIndex(fromJson: index))
            }
        }
    }
    
    public override var dictionary: [String : Any] {
        return [
            pathKey:path ?? "",
            indexesKey:indexes.map{ $0.dictionary }
        ]
    }
}

public class ADIndex {

    let kindKey      = "kind"
    let dataTypeKey  = "dataType"
    let precisionKey = "precision"
    
    public private(set) var kind:       ADIndexKind?
    public private(set) var dataType:   ADDataType?
    public private(set) var precision:  Int16?

    
    public init(_ indexKind:String, type: ADDataType? = nil) {
        switch indexKind {
        case ADIndexKind.hash.rawValue:     kind = .hash
        case ADIndexKind.range.rawValue:    kind = .range
        case ADIndexKind.spatial.rawValue:  kind = .spatial
        default: kind = nil
        }
        dataType = type
    }
    
    public init(_ indexKind:Int, type: ADDataType? = nil) {
        switch indexKind {
        case ADIndexKind.hash.index:    kind = .hash
        case ADIndexKind.range.index:   kind = .range
        case ADIndexKind.spatial.index: kind = .spatial
        default: kind = nil
        }
        dataType = type
    }
    
    public init(fromJson dict: [String:Any]) {
        if let kindRaw = dict[kindKey] as? String, let kind = ADIndexKind(rawValue: kindRaw) { self.kind = kind }
        if let dataTypeRaw = dict[dataTypeKey] as? String, let dataType = ADDataType(rawValue: dataTypeRaw) { self.dataType = dataType }
        if let precision = dict[precisionKey] as? Int16 { self.precision = precision }
    }
    
    public var dictionary: [String : Any] {
        return [
            kindKey:kind?.rawValue ?? "",
            dataTypeKey:dataType?.rawValue ?? "",
            precisionKey:precision ?? ""
        ]
    }
}


public enum ADIndexKind: String {
    case hash       = "Hash"
    case range      = "Range"
    case spatial    = "Spatial"
    
    public init?(_ int: Int) {
        switch int {
        case 0: self = .hash
        case 1: self = .range
        case 2: self = .spatial
        default: return nil
        }
    }
    
    public var index: Int {
        switch self {
        case .hash:     return 0
        case .range:    return 1
        case .spatial:  return 2
        }
    }
}


public enum ADIndexMode: String {
    case consistent = "consistent"
    case lazy       = "lazy"
    case none       = "none"
    
    public init?(_ int: Int) {
        switch int {
        case 0: self = .consistent
        case 1: self = .lazy
        case 2: self = .none
        default: return nil
        }
    }
    
    public var index: Int {
        switch self {
        case .consistent:   return 0
        case .lazy:         return 1
        case .none:         return 2
        }
    }
}


public enum ADDataType: String {
    case lineString = "LineString"
    case number     = "Number"
    case point      = "Point"
    case polygon    = "Polygon"
    case string     = "String"
    
    public init?(_ int: Int) {
        switch int {
        case 0: self = .lineString
        case 1: self = .number
        case 2: self = .point
        case 3: self = .polygon
        case 4: self = .string
        default: return nil
        }
    }
    
    public var index: Int {
        switch self {
        case .lineString:   return 0
        case .number:       return 1
        case .point:        return 2
        case .polygon:      return 3
        case .string:       return 4
        }
    }
}

