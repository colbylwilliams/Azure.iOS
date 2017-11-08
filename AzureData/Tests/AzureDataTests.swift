//
//  AzureDataTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class AzureDataTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0

    var ensureDatabase:     Bool = false
    var ensureCollection:   Bool = false
    var ensureDocument:     Bool = false

    fileprivate(set) var database: ADDatabase?
    fileprivate(set) var collection: ADCollection?
    fileprivate(set) var document: ADDocument?
    
    var resourceName: String?
    var resourceType: ADResourceType!
    
    var rname: String { return resourceName ?? resourceType.name }
    
    var databaseId:     String { return "\(rname)TestsDatabase" }
    var collectionId:   String { return "\(rname)TestsCollection" }
    var documentId:     String { return "\(rname)TestsDocument" }
    var resourceId:     String { return "\(rname)Tests\(rname)" }
    var replacedId:     String { return "\(rname)Replaced" }

    
    let random: Int = 12
    
    let customStringKey = "customStringKey"
    let customStringValue = "customStringValue"
    let customNumberKey = "customNumberKey"
    let customNumberValue = 86
    
    
    lazy var createExpectation  = self.expectation(description: "should create and return \(rname)")
    lazy var listExpectation    = self.expectation(description: "should return a list of \(rname)")
    lazy var getExpectation     = self.expectation(description: "should get and return \(rname)")
    lazy var deleteExpectation  = self.expectation(description: "should delete \(rname)")
    lazy var queryExpectation   = self.expectation(description: "should query \(rname)")
    lazy var replaceExpectation = self.expectation(description: "should replace \(rname)")    

    var deleteSuccess = false
    
    
    override func setUp() {
        super.setUp()
        
        // AzureData.setup("<Database Name>", key: "<Database Key>", keyType: .master, verboseLogging: true)

        if !AzureData.isSetup() {
            
            let bundle = Bundle(for: type(of: self))
            
            if let accountName = bundle.infoDictionary?["ADDatabaseAccountName"] as? String,
                let accountKey = bundle.infoDictionary?["ADDatabaseAccountKey"]  as? String {
            
                AzureData.setup(accountName, key: accountKey, verboseLogging: true)
            }
        }
        
        if ensureDatabase {
        
            let initGetDatabaseExpectation = self.expectation(description: "Should get database")
            var initGetResponse: ADResponse<ADDatabase>?
            

            AzureData.get(databaseWithId: databaseId) { r in
                initGetResponse = r
                initGetDatabaseExpectation.fulfill()
            }
            
            wait(for: [initGetDatabaseExpectation], timeout: timeout)
            
            database = initGetResponse?.resource
            
            if database == nil {
                
                let initCreateDatabaseExpectation = self.expectation(description: "Should initialize database")
                var initCreateResponse: ADResponse<ADDatabase>?

                AzureData.create(databaseWithId: databaseId) { r in
                    initCreateResponse = r
                    initCreateDatabaseExpectation.fulfill()
                }
                
                wait(for: [initCreateDatabaseExpectation], timeout: timeout)
                
                database = initCreateResponse?.resource
            }
            
            XCTAssertNotNil(database)
            
            if ensureCollection, let database = database {
                
                let initGetCollectionExpectation = self.expectation(description: "Should get collection")
                var initGetCollectionResponse: ADResponse<ADCollection>?
                
                database.get(collectionWithId: collectionId) { r in
                    initGetCollectionResponse = r
                    initGetCollectionExpectation.fulfill()
                }
                
                wait(for: [initGetCollectionExpectation], timeout: timeout)
                
                collection = initGetCollectionResponse?.resource
                
                if collection == nil {
                    
                    let initCreateCollectionExpectation = self.expectation(description: "Should initialize collection")
                    var initCreateCollectionResponse: ADResponse<ADCollection>?

                    database.create(collectionWithId: collectionId) { r in
                        initCreateCollectionResponse = r
                        initCreateCollectionExpectation.fulfill()
                    }
                    
                    wait(for: [initCreateCollectionExpectation], timeout: timeout)
                    
                    collection = initCreateCollectionResponse?.resource
                }
                
                XCTAssertNotNil(collection)
                
                if ensureDocument, let collection = collection {
                    
                    let initGetDocumentExpectation = self.expectation(description: "Should get document")
                    var initGetDocumentResponse: ADResponse<ADDocument>?
                    
                    AzureData.get(documentWithId: documentId, as: ADDocument.self, inCollection: collection.id, inDatabase: database.id) { r in
                        initGetDocumentResponse = r
                        initGetDocumentExpectation.fulfill()
                    }
                    
                    wait(for: [initGetDocumentExpectation], timeout: timeout)
                    
                    document = initGetDocumentResponse?.resource
                    
                    if document == nil {
                        
                        let initCreateDocumentExpectation = self.expectation(description: "Should initialize document")
                        var initCreateDocumentResponse: ADResponse<ADDocument>?
                        
                        collection.create(ADDocument(documentId)) { r in
                            initCreateDocumentResponse = r
                            initCreateDocumentExpectation.fulfill()
                        }
                        
                        wait(for: [initCreateDocumentExpectation], timeout: timeout)
                        
                        document = initCreateDocumentResponse?.resource
                    }
                    
                    XCTAssertNotNil(document)

                }
            }
        }
        
        XCTAssert(AzureData.isSetup(), "AzureData setup failed")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}