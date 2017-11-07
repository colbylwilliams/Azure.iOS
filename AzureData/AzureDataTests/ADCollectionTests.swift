//
//  ADCollectionTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADCollectionTests: AzureDataTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCollectionCrud() {
        
        let databaseId      = "CollectionTestsDatabase"
        let collectionId    = "CollectionTests"
        
        let createExpectation   = self.expectation(description: "should create and return collection")
        let listExpectation     = self.expectation(description: "should list and return collections")
        let getExpectation      = self.expectation(description: "should get and return collection")
        let deleteExpectation   = self.expectation(description: "should delete collection")

        var createResponse: ADResponse<ADCollection>?
        var listResponse:   ADListResponse<ADCollection>?
        var getResponse:    ADResponse<ADCollection>?
        
        var deleteSuccess = false
        
        
        // Create
        AzureData.create(collectionWithId: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.get(collectionsIn: databaseId) { r in
            listResponse = r
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Get
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(collectionWithId: collectionId, inDatabase: databaseId) { r in
                getResponse = r
                getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)

        
        // Delete
        if createResponse?.result.isSuccess ?? false {
        
            AzureData.delete(ADCollection(collectionId), fromDatabase: databaseId) { s in
                deleteSuccess = s
                deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
