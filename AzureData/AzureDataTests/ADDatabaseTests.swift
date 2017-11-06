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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDatabaseIsCreatedAndDeleted() {
        
        let databaseId      = "DatabaseTests"
        
        let createExpectation = self.expectation(description: "should create and return database")
        let deleteExpectation = self.expectation(description: "should delete database")
        
        var createResponse: ADResponse<ADDatabase>?
        var deleteSuccess = false
        
        // Create
        AzureData.create(databaseWithId: databaseId) { r in
            createResponse = r
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        // Delete
        AzureData.delete(ADDatabase(databaseId)) { s in
            deleteSuccess = s
            deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteSuccess)
    }
}
