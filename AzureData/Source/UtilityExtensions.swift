//
//  UtilityExtensions.swift
//  AzureData
//
//  Created by Colby Williams on 10/21/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var valueOrEmpty: String {
        return self ?? ""
    }
    
    var valueOrNilString: String {
        return self ?? "nil"
    }
    
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
    
    var isValidResourceId: Bool {
        return self != nil && self!.isValidResourceId
    }
}


extension Optional where Wrapped == Date {
    
    var valueOrEmpty: String {
        return self != nil ? "\(self!.timeIntervalSince1970)" : ""
    }
    
    var valueOrNilString: String {
        return self != nil ? "\(self!.timeIntervalSince1970)" : "nil"
    }
}

extension String {
    
    var isValidResourceId: Bool {
        return !self.containsWhitespace && self.count <= 255
    }
    
    var containsWhitespace: Bool {
        return self.rangeOfCharacter(from: .whitespaces) != nil
    }
}



extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}


extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}

