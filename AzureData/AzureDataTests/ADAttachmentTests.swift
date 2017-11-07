//
//  ADAttachmentTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADAttachmentTests: AzureDataTests {

    override func setUp() {
        resourceType = .attachment
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
    
    
    //func testAttachmentCrud() {
        
        //var createResponse:     ADResponse<ADAttachment>?
        //var listResponse:       ADListResponse<ADAttachment>?
        //var getResponse:        ADResponse<ADAttachment>?
        //var replaceResponse:    ADResponse<ADAttachment>?
        //var queryResponse:      ADListResponse<ADAttachment>?
        
    //}
}
