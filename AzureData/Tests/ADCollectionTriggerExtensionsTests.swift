//
//  ADCollectionTriggerExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class ADCollectionTriggerExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .trigger
        resourceName = "CollectionTriggerExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    //func testTriggerCrud() {
    
    //var createResponse:     ADResponse<ADTrigger>?
    //var listResponse:       ADListResponse<ADTrigger>?
    //var getResponse:        ADResponse<ADTrigger>?
    //var replaceResponse:    ADResponse<ADTrigger>?
    //var queryResponse:      ADListResponse<ADTrigger>?
    
    //}
}
