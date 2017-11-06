//
//  ADDocumentTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADDocumentTests: AzureDataTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDocumentCrud() {
        
        // random number
        let n = Int(arc4random_uniform(100))
        
        let databaseId      = "DocumentTestsDatabase"
        let collectionId    = "DocumentTestsCollection"
        let documentId      = "DocumentTests\(n)"
        
        let createExpectation   = self.expectation(description: "should create and return document")
        let listExpectation     = self.expectation(description: "should list and return documents")
        let getExpectation      = self.expectation(description: "should get and return document")
        let deleteExpectation   = self.expectation(description: "should delete document")
        
        var createResponse: ADResponse<ADDocument>?
        var listResponse:   ADListResponse<ADDocument>?
        var getResponse:    ADResponse<ADDocument>?
        
        var deleteSuccess = false

        
        let document = ADDocument(documentId)
        document["customProperty"] = "customPropertyValue"
        
        
        // Create
        AzureData.create(document, inCollection: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        XCTAssertNotNil(createResponse!.resource!["customProperty"] as? String)
        XCTAssertEqual (createResponse!.resource!["customProperty"] as! String, "customPropertyValue")


        // List
        AzureData.get(documentsAs: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
            listResponse = r
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)

        
        // Get
        AzureData.get(documentWithId: documentId, as: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
            getResponse = r
            getExpectation.fulfill()
        }
        
        wait(for: [getExpectation], timeout: timeout)
        
        XCTAssertNotNil(getResponse?.resource)

        
        // Delete
        AzureData.delete(createResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
