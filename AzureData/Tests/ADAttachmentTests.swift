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
        ensureDocument = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
    
    
    func testAttachmentCrud() {
        
        var createResponse:     ADResponse<ADAttachment>?
        var listResponse:       ADListResponse<ADAttachment>?
        //var getResponse:        ADResponse<ADAttachment>?
        var replaceResponse:    ADResponse<ADAttachment>?
        //var queryResponse:      ADListResponse<ADAttachment>?

        let url: URL! = URL(string: "https://azuredatatests.blob.core.windows.net/attachment-tests/youre%20welcome.jpeg?st=2017-11-07T14%3A00%3A00Z&se=2020-11-08T14%3A00%3A00Z&sp=rl&sv=2017-04-17&sr=c&sig=RAHr6Mee%2Bt7RrDnGHyjgSX3HSqJgj8guhy0IrEMh3KQ%3D")
        
        
        // Create
        AzureData.create (attachmentWithId: resourceId, contentType: "image/jpeg", andMediaUrl: url, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.get(attachmentsOn: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Replace
        if let attachment = createResponse?.resource  {
            
            AzureData.replace(attachmentWithId: attachment.id, contentType: "image/jpeg", andMediaUrl: url, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
                replaceResponse = r
                self.replaceExpectation.fulfill()
            }
            
            wait(for: [replaceExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(replaceResponse?.resource)
        
        
        // Delete
        if let attachment = replaceResponse?.resource ?? createResponse?.resource {
            
            AzureData.delete (attachment, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { s in
                self.deleteSuccess = s
                self.deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
