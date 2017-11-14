//
//  CollectionUserDefinedFunctionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class CollectionUserDefinedFunctionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .udf
        resourceName = "CollectionUserDefinedFunctionExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    //func testUserDefinedFunctionCrud() {
    
    //var createResponse:     Response<UserDefinedFunction>?
    //var listResponse:       ListResponse<UserDefinedFunction>?
    //var getResponse:        Response<UserDefinedFunction>?
    //var replaceResponse:    Response<UserDefinedFunction>?
    //var queryResponse:      ListResponse<UserDefinedFunction>?
    
    //}
}
