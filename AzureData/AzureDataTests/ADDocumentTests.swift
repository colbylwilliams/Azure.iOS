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
        let queryExpectation    = self.expectation(description: "should list and return documents")
        let getExpectation      = self.expectation(description: "should get and return document")
        let deleteExpectation   = self.expectation(description: "should delete document")
        
        var createResponse: ADResponse<ADDocument>?
        var listResponse:   ADListResponse<ADDocument>?
        var queryResponse:  ADListResponse<ADDocument>?
        var getResponse:    ADResponse<ADDocument>?
        
        var deleteSuccess = false

        let customStringKey = "customStringKey"
        let customStringValue = "customStringValue"
        let customNumberKey = "customNumberKey"
        let customNumberValue = n
        
        let document = ADDocument(documentId)
        
        document[customStringKey] = customStringValue
        document[customNumberKey] = customNumberValue
        
        
        // Create
        AzureData.create(document, inCollection: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        XCTAssertNotNil(createResponse!.resource![customStringKey] as? String)
        XCTAssertEqual (createResponse!.resource![customStringKey] as! String, customStringValue)
        XCTAssertNotNil(createResponse!.resource![customNumberKey] as? Int)
        XCTAssertEqual (createResponse!.resource![customNumberKey] as! Int, customNumberValue)


        // List
        AzureData.get(documentsAs: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
            listResponse = r
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)

        
        // Query
        let query = ADQuery.select()
            .from(collectionId)
            .where(customStringKey, is: customStringValue)
            .and(customNumberKey, is: customNumberValue)
            .orderBy("_etag", descending: true)
        
        AzureData.query(documentsIn: collectionId, inDatabase: databaseId, with: query) { r in
            queryResponse = r
            queryExpectation.fulfill()
        }
        
        wait(for: [queryExpectation], timeout: timeout)
        
        XCTAssertNotNil(queryResponse?.resource?.items.first)
        XCTAssertNotNil(queryResponse?.resource?.items.first![customStringKey] as? String)
        XCTAssertEqual (queryResponse?.resource?.items.first![customStringKey] as! String, customStringValue)
        XCTAssertNotNil(queryResponse?.resource?.items.first![customNumberKey] as? Int)
        XCTAssertEqual (queryResponse?.resource?.items.first![customNumberKey] as! Int, customNumberValue)

        
        // Get
        AzureData.get(documentWithId: documentId, as: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
            getResponse = r
            getExpectation.fulfill()
        }
        
        wait(for: [getExpectation], timeout: timeout)
        
        XCTAssertNotNil(getResponse?.resource)
        XCTAssertNotNil(getResponse!.resource![customStringKey] as? String)
        XCTAssertEqual (getResponse!.resource![customStringKey] as! String, customStringValue)
        XCTAssertNotNil(getResponse!.resource![customNumberKey] as? Int)
        XCTAssertEqual (getResponse!.resource![customNumberKey] as! Int, customNumberValue)

        
        // Delete
        AzureData.delete(createResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
