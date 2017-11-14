//
//  DocumentAttachmentExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class DocumentAttachmentExtensionsTests: AzureDataTests {
    
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
    
    //var createResponse:     Response<Attachment>?
    //var listResponse:       ListResponse<Attachment>?
    //var getResponse:        Response<Attachment>?
    //var replaceResponse:    Response<Attachment>?
    //var queryResponse:      ListResponse<Attachment>?
    
    //}
}
