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
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDatabaseCrud() {
        
        let databaseId      = "DatabaseTests"
        
        let createExpectation   = self.expectation(description: "should create and return database")
        let listExpectation     = self.expectation(description: "should list and return databases")
        let getExpectation      = self.expectation(description: "should get and return database")
        let deleteExpectation   = self.expectation(description: "should delete database")

        var createResponse: ADResponse<ADDatabase>?
        var listResponse:   ADListResponse<ADDatabase>?
        var getResponse:    ADResponse<ADDatabase>?
        
        var deleteSuccess = false
        
        
        // Create
        AzureData.create(databaseWithId: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        // List
        AzureData.databases { r in
            listResponse = r
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)

        
        // Get
        AzureData.get(databaseWithId: databaseId) { r in
            getResponse = r
            getExpectation.fulfill()
        }
        
        wait(for: [getExpectation], timeout: timeout)
        
        XCTAssertNotNil(getResponse?.resource)

        
        // Delete
        AzureData.delete(ADDatabase(databaseId)) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
