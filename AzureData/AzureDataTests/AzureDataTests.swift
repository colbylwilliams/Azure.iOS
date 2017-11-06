//
//  AzureDataTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class AzureDataTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        
        // AzureData.setup("<Database Name>", key: "<Database Key>", keyType: .master, verboseLogging: true)

        if !AzureData.isSetup() {
            
            let bundle = Bundle(for: type(of: self))
            
            if let accountName = bundle.infoDictionary?["ADDatabaseAccountName"] as? String,
                let accountKey = bundle.infoDictionary?["ADDatabaseAccountKey"]  as? String {
            
                AzureData.setup(accountName, key: accountKey, verboseLogging: true)
            }
        }
        
        XCTAssert(AzureData.isSetup(), "AzureData setup failed")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
