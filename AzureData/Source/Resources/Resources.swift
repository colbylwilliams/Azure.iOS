//
//  Resources.swift
//  AzureData iOS
//
//  Created by Colby Williams on 11/11/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Resources<T:CodableResource> : Decodable {
    public private(set) var resourceId: String
    public private(set) var count:      Int
    public private(set) var items:      [T]

    private enum CodingKeys : CodingKey {
        case resourceId
        case count
        case items
        
        var stringValue: String {
            switch self {
            case .resourceId: return "_rid"
            case .count: return "_count"
            case .items: return T.list
            }
        }
        
        init?(stringValue: String) {
            switch stringValue {
            case "_rid": self = .resourceId
            case "_count": self = .count
            case T.list: self = .items
            default: return nil
            }
        }
        
        var intValue: Int? { return nil }
        
        init?(intValue: Int) { return nil }
    }
}
