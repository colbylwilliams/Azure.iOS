//
//  ADUserTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADUserTests: AzureDataTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testUserCrud() {
        
        let databaseId      = "UserTestsDatabase"
        let userId          = "UserTestsUser"
        let replacedUserId  = "UserTestsUserReplaced"
        
        let createExpectation   = self.expectation(description: "should create and return user")
        let listExpectation     = self.expectation(description: "should list and return users")
        let getExpectation      = self.expectation(description: "should get and return user")
        let deleteExpectation   = self.expectation(description: "should delete user")
        let replaceExpectation  = self.expectation(description: "should replace user")
        
        var createResponse:     ADResponse<ADUser>?
        var listResponse:       ADListResponse<ADUser>?
        var getResponse:        ADResponse<ADUser>?
        var replaceResponse:    ADResponse<ADUser>?
        
        var deleteSuccess = false
        
        
        // Create
        AzureData.create(userWithId: userId, inDatabase: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.get(usersIn: databaseId) { r in
            listResponse = r
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Get
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(userWithId: userId, inDatabase: databaseId) { r in
                getResponse = r
                getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)
        
        
        // Replace
        if let user = createResponse?.resource  {
         
            AzureData.replace(userWithId: user.id, with: replacedUserId, inDatabase: databaseId) { r in
                replaceResponse = r
                replaceExpectation.fulfill()
            }
            
            wait(for: [replaceExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(replaceResponse?.resource)
        
        
        // Delete
        if let user = replaceResponse?.resource ?? createResponse?.resource {
            
            AzureData.delete(user, fromDatabase: databaseId) { s in
                deleteSuccess = s
                deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
