//
//  ADTriggerTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADTriggerTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .trigger
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
}
