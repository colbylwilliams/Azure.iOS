//
//  AzureDataTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class AzureDataTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0
    
    let databaseId      = "UnitTestsDatabase"
    let collectionId    = "UnitTestsCollections"
    let documentId      = "UnitTestsDocuments"
    
    override func setUp() {
        super.setUp()
		
		if let accountName = ProcessInfo.processInfo.environment["AZURE_COSMOS_DB_ACCOUNT_NAME"],
			let accountKey  = ProcessInfo.processInfo.environment["AZURE_COSMOS_DB_ACCOUNT_KEY"] {
			AzureData.setup(accountName, key: accountKey, verboseLogging: true)
		}
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDatabaseIsCreatedAndDeleted() {
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDatabase>?
        var deleteSuccess = false

        // Create
        AzureData.createDatabase(databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        // Delete
        AzureData.delete(ADDatabase(databaseId)) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
    
    
    func testCollectionIsCreatedAndDeleted() {
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDocumentCollection>?
        var deleteSuccess = false

        // Create
        AzureData.createDocumentCollection(collectionId, collectionId: collectionId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)

        // Delete
        AzureData.delete(ADDocumentCollection(collectionId), databaseId: collectionId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }

    
    func testDocumentIsCreatedAndDeleted() {
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDocument>?
        var deleteSuccess = false
        
        let n = Int(arc4random_uniform(100))
        
        let id = "\(documentId)\(n)"
        
        let document = ADDocument(id)
        document["customProperty"] = "customPropertyValue"

        // Create
        AzureData.createDocument(documentId, collectionId: documentId, document: document) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        XCTAssertNotNil(createResponse!.resource!["customProperty"] as? String)
        XCTAssertEqual(createResponse!.resource!["customProperty"] as! String, "customPropertyValue")
        
        // Delete
        AzureData.delete(createResponse!.resource!, databaseId: documentId, collectionId: documentId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
