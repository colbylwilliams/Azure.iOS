//
//  DocumentTests.swift
//  AzureDataTests
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
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
        
        let doc = DictionaryDocument()
        
        doc["dateTest"] = now
    
        do {
            
            let data = try encoder.encode(doc)
            
            let doc2 = try decoder.decode(DictionaryDocument.self, from: data)
        
            let date = doc2["dateTest"] as! Date
            
            XCTAssertEqual (date.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate)
            
        } catch {
            
            print(error)
        }
    }
    
    
    func testThatCreateValidatesId() {
        
        AzureData.create(DictionaryDocument(idWith256Chars), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
        
        AzureData.create(DictionaryDocument(idWithWhitespace), inCollection: collectionId, inDatabase: databaseId) { r in
            XCTAssertNotNil(r.error)
        }
    }

    
    func testDocumentCrud() {
        
        var createResponse:     Response<DictionaryDocument>?
        var listResponse:       ListResponse<DictionaryDocument>?
        var getResponse:        Response<DictionaryDocument>?
        var queryResponse:      ListResponse<DictionaryDocument>?
        var refreshResponse:    Response<DictionaryDocument>?
        var deleteResponse:     DataResponse?

        
        let newDocument = DictionaryDocument(resourceId)
        
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

        //createResponse?.response?.printHeaders()

        
        
        
        // List
        AzureData.get(documentsAs: DictionaryDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)

        //listResponse?.response?.printHeaders()

        

        
        // Query
        let query = Query.select()
            .from(collectionId)
            .where("\(customStringKey)", is: customStringValue)
            .and("\(customNumberKey)", is: customNumberValue)
            .orderBy("_etag", descending: true)
        
        AzureData.query(documentsIn: collectionId, inDatabase: databaseId, with: query) { (r:ListResponse<DictionaryDocument>?) in
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
        //if createResponse?.result.isSuccess ?? false {
            
            AzureData.get(documentWithId: resourceId, as: DictionaryDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
                getResponse = r
                self.getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        //}
        
        XCTAssertNotNil(getResponse?.resource)
        
        if let document = getResponse?.resource {
            XCTAssertNotNil(document[customStringKey] as? String)
            XCTAssertEqual (document[customStringKey] as! String, customStringValue)
            XCTAssertNotNil(document[customNumberKey] as? Int)
            XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
        }

        //getResponse?.response?.printHeaders()

        
        

        // Refresh
        if getResponse?.result.isSuccess ?? false {
            
            AzureData.refresh(getResponse!.resource!) { r in
                refreshResponse = r
                self.refreshExpectation.fulfill()
            }
            
            wait(for: [refreshExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(refreshResponse?.resource)
        
        if let document = refreshResponse?.resource {
            XCTAssertNotNil(document[customStringKey] as? String)
            XCTAssertEqual (document[customStringKey] as! String, customStringValue)
            XCTAssertNotNil(document[customNumberKey] as? Int)
            XCTAssertEqual (document[customNumberKey] as! Int, customNumberValue)
        }
        
        //refreshResponse?.response?.printHeaders()

        
        
        
        // Delete
        //if getResponse?.result.isSuccess ?? false {
            //AzureData.delete(getResponse!.resource!, fromCollection: collectionId, inDatabase: databaseId) { r in
        getResponse?.resource?.delete { r in
            deleteResponse = r
            self.deleteExpectation.fulfill()
        }
        
        wait(for: [deleteExpectation], timeout: timeout)
        //}
        
        XCTAssert(deleteResponse?.result.isSuccess ?? false)
    }
}
