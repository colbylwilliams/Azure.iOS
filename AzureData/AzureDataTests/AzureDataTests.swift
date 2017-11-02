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
        
        // AzureData.setup("<Database Name>", key: "<Database Key>", keyType: .master, verboseLogging: true)

        let bundle = Bundle(for: type(of: self))
        
        if let accountName = bundle.infoDictionary?["ADDatabaseAccountName"] as? String,
            let accountKey  = bundle.infoDictionary?["ADDatabaseAccountKey"] as? String {
        
            AzureData.setup(accountName, key: accountKey, verboseLogging: true)
        }
        
        XCTAssert(AzureData.isSetup(), "AzureData setup failed")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDatabaseIsCreatedAndDeleted() {
        
        XCTAssert(AzureData.isSetup(), "AzureData in not Setup")
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDatabase>?
        var deleteSuccess = false

        // Create
        AzureData.create(databaseWithId: databaseId) { r in
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
        
        XCTAssert(AzureData.isSetup(), "AzureData in not Setup")
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADCollection>?
        var deleteSuccess = false

        // Create
        AzureData.create(collectionWithId: collectionId, inDatabase: collectionId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)

        // Delete
        AzureData.delete(ADCollection(collectionId), fromDatabase: collectionId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }

    
    func testDocumentIsCreatedAndDeleted() {
        
        XCTAssert(AzureData.isSetup(), "AzureData in not Setup")
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDocument>?
        var deleteSuccess = false
        
        let n = Int(arc4random_uniform(100))
        
        let id = "\(documentId)\(n)"
        
        let document = ADDocument(id)
        document["customProperty"] = "customPropertyValue"

        // Create
        
        AzureData.create(document, inCollection: documentId, inDatabase: documentId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        XCTAssertNotNil(createResponse!.resource!["customProperty"] as? String)
        XCTAssertEqual(createResponse!.resource!["customProperty"] as! String, "customPropertyValue")
        
        // Delete
        AzureData.delete(createResponse!.resource!, fromCollection: documentId, inDatabase: documentId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
