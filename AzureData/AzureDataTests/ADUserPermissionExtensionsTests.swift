//
//  ADUserPermissionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class ADUserPermissionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .permission
        resourceName = "UserPermissionExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    //func testPermissionCrud() {
        
        //var createResponse:     ADResponse<ADPermission>?
        //var listResponse:       ADListResponse<ADPermission>?
        //var getResponse:        ADResponse<ADPermission>?
        //var replaceResponse:    ADResponse<ADPermission>?
        //var queryResponse:      ADListResponse<ADPermission>?
    
    //}
}
