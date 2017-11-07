//
//  ADCollectionDocumentExtensionsTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADCollectionDocumentExtensionsTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .document
        resourceName = "CollectionDocumentExtensions"
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testCollectionCrud() {
        
        var createResponse:     ADResponse<ADDocument>?
        var listResponse:       ADListResponse<ADDocument>?
        var getResponse:        ADResponse<ADDocument>?
        //var replaceResponse:    ADResponse<ADDocument>?
        var queryResponse:      ADListResponse<ADDocument>?

        
        if let collection = self.collection {
        
            let newDocument = ADDocument(resourceId)
            
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
            collection.get(documentsAs: ADDocument.self) { r in
                listResponse = r
                self.listExpectation.fulfill()
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
                
                collection.get(documentWithResourceId: document.resourceId, as: ADDocument.self) { r in
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
                
                collection.delete(document) { s in
                    self.deleteSuccess = s
                    self.deleteExpectation.fulfill()
                }
                
                wait(for: [deleteExpectation], timeout: timeout)
            }
            
            XCTAssert(deleteSuccess)
        }
    }
}

