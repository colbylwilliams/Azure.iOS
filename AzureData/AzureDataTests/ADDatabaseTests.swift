//
//  ADDatabaseTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADDatabaseTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .database
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testDatabaseCrud() {
        
        var createResponse: ADResponse<ADDatabase>?
        var listResponse:   ADListResponse<ADDatabase>?
        var getResponse:    ADResponse<ADDatabase>?
        
        
        // Create
        AzureData.create(databaseWithId: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.databases { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)

        
        // Get
        AzureData.get(databaseWithId: databaseId) { r in
            getResponse = r
            self.getExpectation.fulfill()
        }
        
        wait(for: [getExpectation], timeout: timeout)
        
        XCTAssertNotNil(getResponse?.resource)

        
        // Delete
        AzureData.delete(ADDatabase(databaseId)) { s in
            self.deleteSuccess = s
            self.deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
