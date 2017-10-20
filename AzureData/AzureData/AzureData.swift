//
//  AzureData.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation


public func isSetup() -> Bool { return SessionManager.default.setup }


public func setup (_ name: String, key: String, keyType: ADTokenType) {
	return SessionManager.default.setup(name, key: key, keyType: keyType)
}



// MARK: - Database

// get
public func database (_ databaseId: String, callback: @escaping (ADDatabase?) -> ()) {
	return SessionManager.default.database(databaseId, callback: callback)
}

// list
public func databases (callback: @escaping (ADResourceList<ADDatabase>?) -> ()) {
	return SessionManager.default.databases(callback: callback)
}

// create
public func createDatabase (_ databaseId: String, callback: @escaping (ADDatabase?) -> ()) {
	return SessionManager.default.createDatabase(databaseId, callback: callback)
}

// delete
public func delete (_ resource: ADDatabase, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, callback: callback)
}
	


// MARK: - DocumentCollection

// get
public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADDocumentCollection?) -> ()) {
	return SessionManager.default.documentCollection(databaseId, collectionId: collectionId, callback: callback)
}

// list
public func documentCollections (_ databaseId: String, callback: @escaping (ADResourceList<ADDocumentCollection>?) -> ()) {
	return SessionManager.default.documentCollections(databaseId, callback: callback)
}

//create
public func createDocumentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADDocumentCollection?) -> ()) {
	return SessionManager.default.createDocumentCollection(databaseId, collectionId: collectionId, callback: callback)
}

//delete
public func delete (_ resource: ADDocumentCollection, databaseId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, callback: callback)
}



// MARK: - Document

// get
public func document<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, documentId: String, callback: @escaping (T?) -> ()) {
	return SessionManager.default.document(documentType, databaseId: databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// list
public func documents<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, callback: @escaping (ADResourceList<T>?) -> ()) {
	return SessionManager.default.documents(documentType, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// create
public func createDocument<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (T?) -> ()) {
	return SessionManager.default.createDocument(databaseId, collectionId: collectionId, document: document, callback: callback)
}

// delete
public func delete (_ resource: ADDocument, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}
