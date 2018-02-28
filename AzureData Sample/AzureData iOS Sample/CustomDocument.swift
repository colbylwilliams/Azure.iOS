//
//  CustomDocument.swift
//  AzureData iOS Sample
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AzureData


//typealias documentType = DictionaryDocument
typealias documentType = CustomDocument


class CustomDocument: Document {
    
    var testNumber: Double?
    var testDate:   Date?
    var testString: String?

    
    public override init () { super.init() }
    public override init (_ id: String) { super.init(id) }

    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        testNumber  = try container.decode(Double.self, forKey: .testNumber)
        testDate    = try container.decode(Date.self,   forKey: .testDate)
        testString  = try container.decode(String.self, forKey: .testString)
    }
    
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(testNumber,    forKey: .testNumber)
        try container.encode(testDate,      forKey: .testDate)
        try container.encode(testString,    forKey: .testString)
    }
    
    
    override var debugDescription: String {
        return "\(super.debugDescription)\n\ttestNumber : \(testNumber ?? 0)\n\ttestDate : \(testDate?.debugDescription ?? "nil")\n\ttestString : \(testString ?? "nil")\n--"
    }
}


private extension CustomDocument {
    
    private enum CodingKeys: String, CodingKey {
        case testNumber
        case testDate
        case testString
    }
}
