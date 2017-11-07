//
//  ADDatabaseCollectionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADDatabaseCollectionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .collection
        resourceName = "DatabaseCollectionExtensions"
        ensureDatabase = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }

    
    func testDatabaseCrud() {
        
        if let database = self.database {
            
            var createResponse:     ADResponse<ADCollection>?
            var listResponse:       ADListResponse<ADCollection>?
            var getResponse:        ADResponse<ADCollection>?
            //var replaceResponse:    ADResponse<ADCollection>?
            //var queryResponse:      ADListResponse<ADCollection>?

            
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
                
                database.delete(collection) { s in
                    self.deleteSuccess = s
                    self.deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteSuccess)
        }
    }
}
