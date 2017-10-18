//
//  AzureData.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public func setup (_ name: String, key: String, keyType: ADTokenType) {
	return SessionManager.default.setup(name, key: key, keyType: keyType)
}

public func database (_ databaseId: String, callback: @escaping (ADDatabase?) -> ()) {
	return SessionManager.default.database(databaseId, callback: callback)
}


public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADDocumentCollection?) -> ()) {
	return SessionManager.default.documentCollection(databaseId, collectionId: collectionId, callback: callback)
}


public func document<T: ADDocument> (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (T?) -> ()) {
	return SessionManager.default.document(databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}
