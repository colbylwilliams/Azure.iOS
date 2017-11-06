//
//  ADDatabaseExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADDatabaseExtensionsTests: AzureDataTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDatabaseCrud() {
        
        let databaseId      = "DatabaseExtensionsTestsDatabase"
        let collectionId    = "DatabaseExtensionsTestsCollection"
        
        let initExpectation     = self.expectation(description: "should create and return database")
        let deinitExpectation     = self.expectation(description: "should create and return database")
        let createExpectation   = self.expectation(description: "should create and return collection")
        let listExpectation     = self.expectation(description: "should list and return collections")
        let getExpectation      = self.expectation(description: "should get and return collection")
        let deleteExpectation   = self.expectation(description: "should delete collection")
        
        var initRespoonse:  ADResponse<ADDatabase>?
        var createResponse: ADResponse<ADCollection>?
        var listResponse:   ADListResponse<ADCollection>?
        var getResponse:    ADResponse<ADCollection>?
        
        var deleteSuccess = false
        var deinitSuccess = false
        
        
        // Init (Create Database)
        AzureData.create(databaseWithId: databaseId) { r in
            initRespoonse = r
            initExpectation.fulfill()
        }
        
        wait(for: [initExpectation], timeout: timeout)
        
        XCTAssertNotNil(initRespoonse?.resource)
        
        
        if let database = initRespoonse?.resource {
            
            // Create
            database.create(collectionWithId: collectionId) { r in
                createResponse = r
                createExpectation.fulfill()
            }
            
            wait(for: [createExpectation], timeout: timeout)
            
            XCTAssertNotNil(createResponse?.resource)
            
            
            // List
            database.getCollections { r in
                listResponse = r
                listExpectation.fulfill()
            }
            
            wait(for: [listExpectation], timeout: timeout)
            
            XCTAssertNotNil(listResponse?.resource)
            
            
            // Get
            database.get(collectionWithId: collectionId) { r in
                getResponse = r
                getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
            
            XCTAssertNotNil(getResponse?.resource)
            
            
            // Delete
            database.delete(ADCollection(collectionId)) { s in
                deleteSuccess = s
                deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
            
            XCTAssert(deleteSuccess)
            

            // Deinit Delete
            AzureData.delete(database) { s in
                deinitSuccess = s
                deinitExpectation.fulfill()
            }
            
            wait(for: [deinitExpectation], timeout: timeout)
            
            XCTAssert(deinitSuccess)
        }
    }
}


