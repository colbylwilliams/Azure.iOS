//
//  DocumentTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class DocumentTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .document
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }

    
    func testHandleDate() {
        
        let encoder = DocumentClient.default.jsonEncoder
        let decoder = DocumentClient.default.jsonDecoder
        
        let now = Date()
        
        let doc = Document()
        
        doc["dateTest"] = now
    
        do {
            
            let data = try encoder.encode(doc)
            
            let doc2 = try decoder.decode(Document.self, from: data)
        
            let date = doc2["dateTest"] as! Date
            
            XCTAssertEqual (date.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate)
            
        } catch {
            
            print(error)
        }
    }
    
    
    func testThatCreateValidatesId() {
        
        AzureData.create(Document(idWith256Chars), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
        
        AzureData.create(Document(idWithWhitespace), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
    }

    
    func testDocumentCrud() {
        
        var createResponse:     Response<Document>?
        var listResponse:       ListResponse<Document>?
        var getResponse:        Response<Document>?
        //var replaceResponse:    Response<Document>?
        var queryResponse:      ListResponse<Document>?
        var deleteResponse:     DataResponse?

        
        let newDocument = Document(resourceId)
        
        newDocument[customStringKey] = customStringValue
        newDocument[customNumberKey] = customNumberValue
        
        
        // Create
        AzureData.create(newDocument, inCollection: collectionId, inDatabase: databaseId) { r in
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
        AzureData.get(documentsAs: Document.self, inCollection: collectionId, inDatabase: databaseId) { r in
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
        
        AzureData.query(documentsIn: collectionId, inDatabase: databaseId, with: query) { r in
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
        if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(documentWithId: resourceId, as: Document.self, inCollection: collectionId, inDatabase: databaseId) { r in
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
        if createResponse?.result.isSuccess ?? false {
         
            AzureData.delete(createResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { r in
                deleteResponse = r
                self.deleteExpectation.fulfill()
            }
            
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteResponse?.result.isSuccess ?? false)
    }
}
