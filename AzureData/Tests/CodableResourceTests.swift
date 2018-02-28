//
//  CodableResourceTests.swift
//  AzureData
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import AzureData

class CodableResourceTests: XCTestCase {
    
    let jsonEncoder: JSONEncoder = {
        let encoder = DocumentClient.default.jsonEncoder
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    let jsonDecoder: JSONDecoder = {
        let decoder = DocumentClient.default.jsonDecoder
        return decoder
    }()

    let documentJson = """
{
    "id":"DocumentTestsDocument",
    "_rid":"TC1AAMDvwgB4AAAAAAAAAA==",
    "customNumberKey":86,
    "customStringKey":"customStringValue",
    "customBoolKey":true,
    "_self":"dbs/TC1AAA==/colls/TC1AAMDvwgA=/docs/TC1AAMDvwgB4AAAAAAAAAA==/",
    "_etag":"\\\"88005b65-0000-0000-0000-5a0dfabb0000\\\"",
    "_attachments":"attachments/",
    "_ts":1510865595
}
""".data(using: .utf8)!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testDocumentDecode() {
        
        var doc: Document?
        
        do {
            
            doc = try jsonDecoder.decode(Document.self, from: documentJson)
        
            print()
            print(doc!)
            print()
            
        } catch {
            print()
            print(error)
            print()
        }
        
        XCTAssertNotNil(doc)
    }
    
    func testDocumentEncode() {
        
        let doc = Document.testDocument
        
        do {
            
            let json = try jsonEncoder.encode(doc)
            
            print()
            print(String.init(data: json, encoding: .utf8)!)
            print()
            
        } catch {
            print()
            print(error)
            print()
        }
        
        XCTAssertNotNil(doc)
    }
}
