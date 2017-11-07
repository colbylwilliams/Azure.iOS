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
        
        let createDatabaseExpectation     = self.expectation(description: "should create and return database")
        let deleteDatabaseExpectation     = self.expectation(description: "should delete database")

        let createExpectation   = self.expectation(description: "should create and return collection")
        let listExpectation     = self.expectation(description: "should list and return collections")
        let getExpectation      = self.expectation(description: "should get and return collection")
        let deleteExpectation   = self.expectation(description: "should delete collection")
        
        var createDatabaseResponse: ADResponse<ADDatabase>?
        
        var createResponse: ADResponse<ADCollection>?
        var listResponse:   ADListResponse<ADCollection>?
        var getResponse:    ADResponse<ADCollection>?
        
        var deleteDatabaseSuccess = false
        var deleteSuccess = false
        
        
        // Create Database
        AzureData.create(databaseWithId: databaseId) { r in
            createDatabaseResponse = r
            createDatabaseExpectation.fulfill()
        }
        
        wait(for: [createDatabaseExpectation], timeout: timeout)
        
        XCTAssertNotNil(createDatabaseResponse?.resource)
        
        
        if let database = createDatabaseResponse?.resource {
            

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
            if let collection = createResponse?.resource {
                
                database.get(collectionWithId: collection.id) { r in
                    getResponse = r
                    getExpectation.fulfill()
                }
                
                wait(for: [getExpectation], timeout: timeout)
            }

            XCTAssertNotNil(getResponse?.resource)
                
            
            
            
            // Delete
            if let collection = createResponse?.resource {
                
                database.delete(collection) { s in
                    deleteSuccess = s
                    deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteSuccess)

            
            
            // Delete Delete
            AzureData.delete(database) { s in
                deleteDatabaseSuccess = s
                deleteDatabaseExpectation.fulfill()
            }
            
            wait(for: [deleteDatabaseExpectation], timeout: timeout)
            
            XCTAssert(deleteDatabaseSuccess)
        }
    }
}


