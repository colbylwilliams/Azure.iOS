//
//  ADDatabaseUserExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/7/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADDatabaseUserExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .document
        resourceName = "CollectionUserExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
    
    
    func testUserCrud() {
        
        var createResponse:     ADResponse<ADUser>?
        var listResponse:       ADListResponse<ADUser>?
        var getResponse:        ADResponse<ADUser>?
        var replaceResponse:    ADResponse<ADUser>?
        //var queryResponse:      ADListResponse<ADUser>?

        
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
