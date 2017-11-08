//
//  ADPartitionKeyDefinition.swift
//  AzureData
//
//  Created by Colby Williams on 10/20/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADPartitionKeyDefinition {
    
    let pathsKey = "paths"
    
    public private(set) var paths: [String] = []
    
    public init?(fromJson dict: [String:Any]) {
        if let paths = dict[pathsKey] as? [String] {
            for path in paths {
                self.paths.append(path)
            }
        }
    }
    
    public var dictionary: [String:Any] {
        return [ pathsKey:paths ]
    }
}
