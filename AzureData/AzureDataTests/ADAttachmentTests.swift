//
//  ADAttachmentTests.swift
//  AzureDataTests
//
//  Created by Colby Williams on 11/6/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import XCTest

class ADAttachmentTests: AzureDataTests {

    override func setUp() {
        resourceType = .attachment
        ensureDatabase = true
        ensureCollection = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
}
