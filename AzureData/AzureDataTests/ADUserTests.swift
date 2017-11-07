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
        resourceType = .user
        ensureDatabase = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }

    
    func testUserCrud() {
        
        
        var createResponse:     ADResponse<ADUser>?
        var listResponse:       ADListResponse<ADUser>?
        var getResponse:        ADResponse<ADUser>?
        var replaceResponse:    ADResponse<ADUser>?
        
        
        // Create
        AzureData.create(userWithId: resourceId, inDatabase: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.get(usersIn: databaseId) { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Get
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(userWithId: resourceId, inDatabase: databaseId) { r in
                getResponse = r
                self.getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)
        
        
        // Replace
        if let user = createResponse?.resource  {
         
            AzureData.replace(userWithId: user.id, with: replacedId, inDatabase: databaseId) { r in
                replaceResponse = r
                self.replaceExpectation.fulfill()
            }
            
            wait(for: [replaceExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(replaceResponse?.resource)
        
        
        // Delete
        if let user = replaceResponse?.resource ?? createResponse?.resource {
            
            AzureData.delete(user, fromDatabase: databaseId) { s in
                self.deleteSuccess = s
                self.deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteSuccess)
    }
}
