//
//  CustomDocument.swift
//  AzureData iOS Sample
//
//  Created by Colby L Williams on 1/3/18.
//  Copyright © 2018 Colby Williams. All rights reserved.
//

import Foundation
import AzureData

class CustomDocument: Document {
    
    var testNumber: Double?
    var testDate:   Date?
    var testString: String?
    
    override var debugDescription: String {
        return "\(super.debugDescription)\n\ttestNumber : \(testNumber ?? 0)\n\ttestDate : \(testDate?.debugDescription ?? "nil")\n\ttestString : \(testString ?? "nil")\n--"
    }
}
