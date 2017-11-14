//
//  DatabaseTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class DatabaseTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .database
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testDatabaseCrud() {
        
        var createResponse:     Response<Database>?
        var listResponse:       ListResponse<Database>?
        var getResponse:        Response<Database>?
        var deleteResponse:     DataResponse?
        //var replaceResponse:    Response<Database>?
        //var queryResponse:      ListResponse<Database>?

        
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
        AzureData.delete(Database(databaseId)) { r in
            deleteResponse = r
            self.deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        
        XCTAssert(deleteResponse?.result.isSuccess ?? false)
    }
}
