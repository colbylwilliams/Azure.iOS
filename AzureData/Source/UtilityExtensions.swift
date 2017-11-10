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
    
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
    
    var isValidResourceId: Bool {
        return self != nil && self!.isValidResourceId
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
