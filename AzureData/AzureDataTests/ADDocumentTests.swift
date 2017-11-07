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
        let n = random
        
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
        
        let newDocument = ADDocument(documentId)
        
        newDocument[customStringKey] = customStringValue
        newDocument[customNumberKey] = customNumberValue
        
        
        
        // Create
        AzureData.create(newDocument, inCollection: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        if let document = createResponse?.resource {
            
            XCTAssertNotNil(document[customStringKey] as? String)
            XCTAssertEqual (document[customStringKey] as! String, customStringValue)
            XCTAssertNotNil(document[customNumberKey] as? Int)
            XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
        }

        
        
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
        
        if let document = queryResponse?.resource?.items.first {
            
            XCTAssertNotNil(document[customStringKey] as? String)
            XCTAssertEqual (document[customStringKey] as! String, customStringValue)
            XCTAssertNotNil(document[customNumberKey] as? Int)
            XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
        }
        
        
        
        // Get
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(documentWithId: documentId, as: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
                getResponse = r
                getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)
        
        if let document = getResponse?.resource {
            
            XCTAssertNotNil(document[customStringKey] as? String)
            XCTAssertEqual (document[customStringKey] as! String, customStringValue)
            XCTAssertNotNil(document[customNumberKey] as? Int)
            XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
        }

        
        
        // Delete
        if createResponse?.result.isSuccess ?? false {
         
            AzureData.delete(createResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { s in
                deleteSuccess = s
                deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
