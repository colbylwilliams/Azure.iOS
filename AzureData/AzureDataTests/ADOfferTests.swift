//
//  ADOfferTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest
@testable import AzureData

class ADOfferTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .offer
        super.setUp()
    }
    
    override func tearDown() { super.tearDown() }

    
    func testOfferCrud() {
        
        var listResponse:   ADListResponse<ADOffer>?
        var getResponse:    ADResponse<ADOffer>?
        
        
        // List
        AzureData.offers { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        // Get
        if let offer = listResponse?.resource?.items.first {

            AzureData.get(offerWithId: offer.resourceId) { r in
                getResponse = r
                self.getExpectation.fulfill()
            }
            
            wait(for: [getExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(getResponse?.resource)
    }
}
