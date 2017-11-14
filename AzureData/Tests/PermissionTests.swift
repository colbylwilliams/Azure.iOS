//
//  PermissionTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class PermissionTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .permission
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    //func testPermissionCrud() {
        
        //var createResponse:     Response<Permission>?
        //var listResponse:       ListResponse<Permission>?
        //var getResponse:        Response<Permission>?
        //var replaceResponse:    Response<Permission>?
        //var queryResponse:      ListResponse<Permission>?

    //}
}
