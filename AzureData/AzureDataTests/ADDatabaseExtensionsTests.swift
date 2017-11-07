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
        
        let databaseId      = "DatabaseExtensionsCollectionTestsDatabase"
        let collectionId    = "DatabaseExtensionsCollectionTestsCollection"
        
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

            
            
            // Delete Database
            AzureData.delete(database) { s in
                deleteDatabaseSuccess = s
                deleteDatabaseExpectation.fulfill()
            }
            
            wait(for: [deleteDatabaseExpectation], timeout: timeout)
            
            XCTAssert(deleteDatabaseSuccess)
        }
    }
    
    
    func testUserCrud() {
        
        let databaseId      = "DatabaseExtensionsUserTestsDatabase"
        let userId          = "DatabaseExtensionsUserTestsUser"
        let replacedUserId  = "DatabaseExtensionsUserTestsUserReplaced"
        
        let createDatabaseExpectation     = self.expectation(description: "should create and return database")
        let deleteDatabaseExpectation     = self.expectation(description: "should delete database")
        
        let createExpectation   = self.expectation(description: "should create and return user")
        let listExpectation     = self.expectation(description: "should list and return users")
        let getExpectation      = self.expectation(description: "should get and return user")
        let deleteExpectation   = self.expectation(description: "should delete user")
        let replaceExpectation  = self.expectation(description: "should replace user")
        
        var createDatabaseResponse: ADResponse<ADDatabase>?
        
        var createResponse:     ADResponse<ADUser>?
        var listResponse:       ADListResponse<ADUser>?
        var getResponse:        ADResponse<ADUser>?
        var replaceResponse:    ADResponse<ADUser>?
        
        var deleteSuccess = false
        var deleteDatabaseSuccess = false
        
        
        // Create Database
        AzureData.create(databaseWithId: databaseId) { r in
            createDatabaseResponse = r
            createDatabaseExpectation.fulfill()
        }
        
        wait(for: [createDatabaseExpectation], timeout: timeout)
        
        XCTAssertNotNil(createDatabaseResponse?.resource)
        
        
        if let database = createDatabaseResponse?.resource {

            // Create
            database.create(userWithId: userId) { r in
                createResponse = r
                createExpectation.fulfill()
            }
            
            wait(for: [createExpectation], timeout: timeout)
            
            XCTAssertNotNil(createResponse?.resource)
            
            
            // List
            database.getUsers() { r in
                listResponse = r
                listExpectation.fulfill()
            }
            
            wait(for: [listExpectation], timeout: timeout)
            
            XCTAssertNotNil(listResponse?.resource)
            
            
            // Get
            if createResponse?.result.isSuccess ?? false {
                
                database.get(userWithId: userId) { r in
                    getResponse = r
                    getExpectation.fulfill()
                }
                
                wait(for: [getExpectation], timeout: timeout)
            }
            
            XCTAssertNotNil(getResponse?.resource)
            
            
            // Replace
            if let user = createResponse?.resource  {
                
                database.replace(userWithId: user.id, with: replacedUserId) { r in
                    replaceResponse = r
                    replaceExpectation.fulfill()
                }
                
                wait(for: [replaceExpectation], timeout: timeout)
            }
            
            XCTAssertNotNil(replaceResponse?.resource)
            
            
            // Delete
            if let user = replaceResponse?.resource ?? createResponse?.resource {
                
                database.delete(user) { s in
                    deleteSuccess = s
                    deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteSuccess)
            
            
            // Delete Database
            AzureData.delete(database) { s in
                deleteDatabaseSuccess = s
                deleteDatabaseExpectation.fulfill()
            }
            
            wait(for: [deleteDatabaseExpectation], timeout: timeout)
            
            XCTAssert(deleteDatabaseSuccess)
        }
    }
}


