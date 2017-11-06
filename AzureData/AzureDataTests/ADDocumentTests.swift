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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDocumentIsCreatedAndDeleted() {
        
        let databaseId      = "DocumentTestsDatabase"
        let collectionId    = "DocumentTestsCollection"
        let documentId      = "DocumentTests"
        
        let createExpectation = self.expectation(description: "should create and return document")
        let deleteExpectation = self.expectation(description: "should delete document")
        
        var createResponse: ADResponse<ADDocument>?
        var deleteSuccess = false
        
        let n = Int(arc4random_uniform(100))
        
        let id = "\(documentId)\(n)"
        
        let document = ADDocument(id)
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
        
        // Delete
        AzureData.delete(createResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
