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
        resourceType = .document
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testHandleDate() {
        
        let now = Date()
        
        let doc = ADDocument()
        
        doc["dateTest"] = now
        
        let date = Date(timeIntervalSince1970: doc["dateTest"] as! TimeInterval)
        
        XCTAssertEqual (date.timeIntervalSince1970, now.timeIntervalSince1970)
    }
    
    
    func testThatCreateValidatesId() {
        
        AzureData.create(ADDocument(idWith256Chars), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
        
        AzureData.create(ADDocument(idWithWhitespace), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
    }

    
    func testDocumentCrud() {
        
        var createResponse:     ADResponse<ADDocument>?
        var listResponse:       ADListResponse<ADDocument>?
        var getResponse:        ADResponse<ADDocument>?
        //var replaceResponse:    ADResponse<ADDocument>?
        var queryResponse:      ADListResponse<ADDocument>?

        
        let newDocument = ADDocument(resourceId)
        
        newDocument[customStringKey] = customStringValue
        newDocument[customNumberKey] = customNumberValue
        
        
        // Create
        AzureData.create(newDocument, inCollection: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
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
            self.listExpectation.fulfill()
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
            self.queryExpectation.fulfill()
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
            
            AzureData.get(documentWithId: resourceId, as: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
                getResponse = r
                self.getExpectation.fulfill()
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
                self.deleteSuccess = s
                self.deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
