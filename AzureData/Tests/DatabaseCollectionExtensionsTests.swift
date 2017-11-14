//
//  DatabaseCollectionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class DatabaseCollectionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .collection
        resourceName = "DatabaseCollectionExtensions"
        ensureDatabase = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }

    
    func testDatabaseCrud() {
        
        if let database = self.database {
            
            var createResponse:     Response<DocumentCollection>?
            var listResponse:       ListResponse<DocumentCollection>?
            var getResponse:        Response<DocumentCollection>?
            var deleteResponse:     DataResponse?
            //var replaceResponse:    Response<DocumentCollection>?
            //var queryResponse:      ListResponse<DocumentCollection>?

            
            // Create
            database.create(collectionWithId: collectionId) { r in
                createResponse = r
                self.createExpectation.fulfill()
            }
            
            wait(for: [createExpectation], timeout: timeout)
            
            XCTAssertNotNil(createResponse?.resource)
            
            
            
            // List
            database.getCollections { r in
                listResponse = r
                self.listExpectation.fulfill()
            }
            
            wait(for: [listExpectation], timeout: timeout)
            
            XCTAssertNotNil(listResponse?.resource)
            
            
            
            // Get
            if let collection = createResponse?.resource {
                
                database.get(collectionWithId: collection.id) { r in
                    getResponse = r
                    self.getExpectation.fulfill()
                }
                
                wait(for: [getExpectation], timeout: timeout)
            }

            XCTAssertNotNil(getResponse?.resource)
                
            
            
            
            // Delete
            if let collection = createResponse?.resource {
                
                database.delete(collection) { r in
                    deleteResponse = r
                    self.deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteResponse?.result.isSuccess ?? false)
        }
    }
}
