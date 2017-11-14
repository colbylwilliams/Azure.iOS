//
//  CollectionDocumentExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class CollectionDocumentExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .document
        resourceName = "CollectionDocumentExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testCollectionCrud() {
        
        var createResponse:     Response<Document>?
        var listResponse:       ListResponse<Document>?
        var getResponse:        Response<Document>?
        var deleteResponse:     DataResponse?
        //var replaceResponse:    Response<Document>?
        var queryResponse:      ListResponse<Document>?

        
        if let collection = self.collection {
        
            let newDocument = Document(resourceId)
            
            newDocument[customStringKey] = customStringValue
            newDocument[customNumberKey] = customNumberValue
            
            
            // Create
            collection.create(newDocument) { r in
                createResponse = r
                self.createExpectation.fulfill()
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
            collection.get(documentsAs: Document.self) { r in
                listResponse = r
                self.listExpectation.fulfill()
            }
            
            wait(for: [listExpectation], timeout: timeout)
            
            XCTAssertNotNil(listResponse?.resource)
            
            
            // Query
            let query = Query.select()
                .from(collectionId)
                .where("data.\(customStringKey)", is: customStringValue)
                .and("data.\(customNumberKey)", is: customNumberValue)
                .orderBy("_etag", descending: true)
            
            collection.query(documentsWith: query) { r in
                queryResponse = r
                self.queryExpectation.fulfill()
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
                
                collection.get(documentWithResourceId: document.resourceId, as: Document.self) { r in
                    getResponse = r
                    self.getExpectation.fulfill()
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
                
                collection.delete(document) { r in
                    deleteResponse = r
                    self.deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteResponse?.result.isSuccess ?? false)
        }
    }
}

