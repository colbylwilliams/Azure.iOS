//
//  UserPermissionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class UserPermissionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .permission
        resourceName = "UserPermissionExtensions"
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
