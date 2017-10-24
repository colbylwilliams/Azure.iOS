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
}


