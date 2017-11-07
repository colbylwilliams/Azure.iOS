//
//  ADStoredProcedureTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADStoredProcedureTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .storedProcedure
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    
    override func tearDown() { super.tearDown() }
}
