//
//  DocumentCollectionTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class DocumentCollectionTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .collection
        ensureDatabase = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
    
    
    func testCollectionCrud() {
        
        var createResponse:     Response<DocumentCollection>?
        var listResponse:       ListResponse<DocumentCollection>?
        var getResponse:        Response<DocumentCollection>?
        var deleteResponse:     DataResponse?
        //var replaceResponse:    Response<DocumentCollection>?
        //var queryResponse:      ListResponse<DocumentCollection>?

        
        // Create
        AzureData.create(collectionWithId: resourceId, inDatabase: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.get(collectionsIn: databaseId) { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Get
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(collectionWithId: resourceId, inDatabase: databaseId) { r in
                getResponse = r
                self.getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)

        
        // Delete
        if createResponse?.result.isSuccess ?? false {
        
            AzureData.delete(DocumentCollection(resourceId), fromDatabase: databaseId) { r in
                deleteResponse = r
                self.deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteResponse?.result.isSuccess ?? false)
    }
}
