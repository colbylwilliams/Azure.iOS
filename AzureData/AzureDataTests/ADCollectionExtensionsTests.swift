//
//  ADCollectionExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADCollectionExtensionsTests: AzureDataTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCollectionCrud() {

        
        // random number
        let n = random
        
        let databaseId      = "CollectionExtensionsTestsDatabase"
        let collectionId    = "CollectionExtensionsTestsCollection"
        let documentId      = "CollectionExtensionsTests\(n)"
        
        let createDatabaseExpectation     = self.expectation(description: "should create and return database")
        let createCollectionExpectation   = self.expectation(description: "should create and return collection")
        let deleteDatabaseExpectation     = self.expectation(description: "should delete database")
        let deleteCollectionExpectation   = self.expectation(description: "should delete collection")


        let createExpectation   = self.expectation(description: "should create and return document")
        let listExpectation     = self.expectation(description: "should list and return documents")
        let queryExpectation    = self.expectation(description: "should list and return documents")
        let getExpectation      = self.expectation(description: "should get and return document")
        let deleteExpectation   = self.expectation(description: "should delete document")
        
        var createDatabaseResponse: ADResponse<ADDatabase>?
        var createCollectionResponse: ADResponse<ADCollection>?
        
        var createResponse: ADResponse<ADDocument>?
        var listResponse:   ADListResponse<ADDocument>?
        var queryResponse:  ADListResponse<ADDocument>?
        var getResponse:    ADResponse<ADDocument>?
        
        var deleteDatabaseSuccess = false
        var deleteCollectionSuccess = false
        var deleteSuccess = false
        
        let customStringKey = "customStringKey"
        let customStringValue = "customStringValue"
        let customNumberKey = "customNumberKey"
        let customNumberValue = n
        
        // Create Database
        AzureData.create(databaseWithId: databaseId) { r in
            createDatabaseResponse = r
            createDatabaseExpectation.fulfill()
        }
        
        wait(for: [createDatabaseExpectation], timeout: timeout)
        
        XCTAssertNotNil(createDatabaseResponse?.resource)
        
        
        if let database = createDatabaseResponse?.resource {

            // Create Collection
            database.create(collectionWithId: collectionId) { r in
                createCollectionResponse = r
                createCollectionExpectation.fulfill()
            }
            
            wait(for: [createCollectionExpectation], timeout: timeout)
            
            XCTAssertNotNil(createCollectionResponse?.resource)
            
            if let collection = createCollectionResponse?.resource {
        
                let newDocument = ADDocument(documentId)
                
                newDocument[customStringKey] = customStringValue
                newDocument[customNumberKey] = customNumberValue
                
                
                // Create
                collection.create(newDocument) { r in
                    createResponse = r
                    createExpectation.fulfill()
                }
                
                wait(for: [createExpectation], timeout: timeout)
                
                XCTAssertNotNil(createResponse?.resource)
                
                if let document = createResponse?.resource {
                    
                    XCTAssertNotNil(document[customStringKey] as? String)
                    XCTAssertEqual (document[customStringKey] as! String, customStringValue)
                    XCTAssertNotNil(document[customNumberKey] as? Int)
                    XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
                }
                
                    
                // List
                collection.get(documentsAs: ADDocument.self) { r in
                    listResponse = r
                    listExpectation.fulfill()
                }
                
                wait(for: [listExpectation], timeout: timeout)
                
                XCTAssertNotNil(listResponse?.resource)
                    
                    
                // Query
                let query = ADQuery.select()
                    .from(collectionId)
                    .where(customStringKey, is: customStringValue)
                    .and(customNumberKey, is: customNumberValue)
                    .orderBy("_etag", descending: true)
                
                collection.query(documentsWith: query) { r in
                    queryResponse = r
                    queryExpectation.fulfill()
                }
                
                wait(for: [queryExpectation], timeout: timeout)
                
                XCTAssertNotNil(queryResponse?.resource?.items.first)
                
                if let document = queryResponse?.resource?.items.first {
                    
                    XCTAssertNotNil(document[customStringKey] as? String)
                    XCTAssertEqual (document[customStringKey] as! String, customStringValue)
                    XCTAssertNotNil(document[customNumberKey] as? Int)
                    XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
                }
                
                
                // Get
                if let document = createResponse?.resource {
                    
                    collection.get(documentWithResourceId: document.resourceId, as: ADDocument.self) { r in
                        getResponse = r
                        getExpectation.fulfill()
                    }
                    
                    wait(for: [getExpectation], timeout: timeout)
                }
                
                XCTAssertNotNil(getResponse?.resource)
                
                if let document = getResponse?.resource {
                    
                    XCTAssertNotNil(document[customStringKey] as? String)
                    XCTAssertEqual (document[customStringKey] as! String, customStringValue)
                    XCTAssertNotNil(document[customNumberKey] as? Int)
                    XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
                }

                
                // Delete
                if let document = createResponse?.resource {
                    
                    collection.delete(document) { s in
                        deleteSuccess = s
                        deleteExpectation.fulfill()
                    }
                    
                    wait(for: [deleteExpectation], timeout: timeout)
                }
                
                XCTAssert(deleteSuccess)
               
                
                // Delete Collection
                database.delete(collection) { s in
                    deleteCollectionSuccess = s
                    deleteCollectionExpectation.fulfill()
                }
                
                wait(for: [deleteCollectionExpectation], timeout: timeout)
                
                XCTAssert(deleteCollectionSuccess)
            }
            
            
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

