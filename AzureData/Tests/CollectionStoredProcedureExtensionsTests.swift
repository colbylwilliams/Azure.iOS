//
//  CollectionStoredProcedureExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class CollectionStoredProcedureExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .storedProcedure
        resourceName = "CollectionStoredProcedureExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    //func testStoredProcedureCrud() {
    
    //var createResponse:     Response<StoredProcedure>?
    //var listResponse:       ListResponse<StoredProcedure>?
    //var getResponse:        Response<StoredProcedure>?
    //var replaceResponse:    Response<StoredProcedure>?
    //var queryResponse:      ListResponse<StoredProcedure>?
    
    //}
}
