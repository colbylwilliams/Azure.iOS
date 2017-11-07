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
        resourceType = .collection
        resourceName = "DatabaseExtensions"
        ensureDatabase = true
        super.setUp()
    }

    
    override func tearDown() { super.tearDown() }

    
    func testDatabaseCrud() {
        
        var createResponse: ADResponse<ADCollection>?
        var listResponse:   ADListResponse<ADCollection>?
        var getResponse:    ADResponse<ADCollection>?
        
        
        if let database = self.database {
            
            
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
    
    
    func testUserCrud() {
        
        var createResponse:     ADResponse<ADUser>?
        var listResponse:       ADListResponse<ADUser>?
        var getResponse:        ADResponse<ADUser>?
        var replaceResponse:    ADResponse<ADUser>?
        
        
        if let database = self.database {

            // Create
            database.create(userWithId: resourceId) { r in
                createResponse = r
                self.createExpectation.fulfill()
            }
            
            wait(for: [createExpectation], timeout: timeout)
            
            XCTAssertNotNil(createResponse?.resource)
            
            
            // List
            database.getUsers() { r in
                listResponse = r
                self.listExpectation.fulfill()
            }
            
            wait(for: [listExpectation], timeout: timeout)
            
            XCTAssertNotNil(listResponse?.resource)
            
            
            // Get
            if createResponse?.result.isSuccess ?? false {
                
                database.get(userWithId: resourceId) { r in
                    getResponse = r
                    self.getExpectation.fulfill()
                }
                
                wait(for: [getExpectation], timeout: timeout)
            }
            
            XCTAssertNotNil(getResponse?.resource)
            
            
            // Replace
            if let user = createResponse?.resource  {
                
                database.replace(userWithId: user.id, with: replacedId) { r in
                    replaceResponse = r
                    self.replaceExpectation.fulfill()
                }
                
                wait(for: [replaceExpectation], timeout: timeout)
            }
            
            XCTAssertNotNil(replaceResponse?.resource)
            
            
            // Delete
            if let user = replaceResponse?.resource ?? createResponse?.resource {
                
                database.delete(user) { s in
                    self.deleteSuccess = s
                    self.deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteSuccess)
        }
    }
}
