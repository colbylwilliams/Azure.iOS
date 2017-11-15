//
//  ADError.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADError: Error {

    let codeKey     = "code"
    let messageKey  = "message"

    public private(set) var code:    String
    public private(set) var message: String

    required public init?(fromJson dict: [String:Any]) {
        //super.init(fromJson: dict)
        
        if let code = dict[codeKey] as? String { self.code = code } else { self.code = "error" }
        if let message = dict[messageKey] as? String { self.message = message } else { self.message = "unknown error" }
    }
    
    init() {
        code = "error"
        message = "unknown error"
    }
    
    init (_ message: String) {
        code = "error"
        self.message = message
    }
    
    init (_ error: Error) {
        code = "error"
        message = error.localizedDescription
    }
    
    public func printLog() {
        print("")
        print("ADError")
        print("\t\(code)")
        print("\t\(message)")
        print("")
    }
}


extension ADError {
    static let unknownError = ADError("A unknown error occured.")
    static let setupError = ADError("AzureData is not setup.  Must call AzureData.setup() before attempting CRUD operations on resources.")
    static let invalidIdError = ADError("Cosmos DB Resource IDs must not exceed 255 characters and cannot contain whitespace")
    static let jsonError = ADError("Error: Could not serialize document to JSON")
    static let incompleteIds = ADError("This resource is missing the selfLink and/or resourceId properties.  Use an override that takes parent resource or ids instead.")
}
