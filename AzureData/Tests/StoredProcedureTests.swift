//
//  StoredProcedureTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class StoredProcedureTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .storedProcedure
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }
    
    
    func testThatCreateValidatesId() {
        
        AzureData.create (storedProcedureWithId: idWith256Chars, andBody: "", inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
        
        AzureData.create (storedProcedureWithId: idWithWhitespace, andBody: "", inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
    }

    
    //func testStoredProcedureCrud() {
    
    //var createResponse:     Response<StoredProcedure>?
    //var listResponse:       ListResponse<StoredProcedure>?
    //var getResponse:        Response<StoredProcedure>?
    //var replaceResponse:    Response<StoredProcedure>?
    //var queryResponse:      ListResponse<StoredProcedure>?
    
    //}
    
}
