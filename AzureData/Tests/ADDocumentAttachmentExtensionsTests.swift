//
//  ADDocumentAttachmentExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class ADDocumentAttachmentExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .attachment
        resourceName = "DocumentAttachmentExtensions"
        ensureDatabase = true
        ensureCollection = true
        ensureDocument = true
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
