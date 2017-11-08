//
//  ADCollectionUserDefinedFunctionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class ADCollectionUserDefinedFunctionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .udf
        resourceName = "CollectionUserDefinedFunctionExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    //func testUserDefinedFunctionCrud() {
    
    //var createResponse:     ADResponse<ADUserDefinedFunction>?
    //var listResponse:       ADListResponse<ADUserDefinedFunction>?
    //var getResponse:        ADResponse<ADUserDefinedFunction>?
    //var replaceResponse:    ADResponse<ADUserDefinedFunction>?
    //var queryResponse:      ADListResponse<ADUserDefinedFunction>?
    
    //}
}
