//
//  ADUserDefinedFunctionTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADUserDefinedFunctionTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .udf
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