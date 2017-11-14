//
//  TriggerTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class TriggerTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .trigger
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    //func testTriggerCrud() {
    
    //var createResponse:     Response<Trigger>?
    //var listResponse:       ListResponse<Trigger>?
    //var getResponse:        Response<Trigger>?
    //var replaceResponse:    Response<Trigger>?
    //var queryResponse:      ListResponse<Trigger>?
    
    //}
    
}
