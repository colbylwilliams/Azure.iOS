//
//  AzureData.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation


public func isSetup() -> Bool { return SessionManager.default.setup }

public func printResponseJson(_ print: Bool) { SessionManager.default.printResponseJson = print }

// setup
public func setup (_ name: String, key: String, keyType: ADTokenType) {
	return SessionManager.default.setup(name, key: key, keyType: keyType)
}




// MARK: - Database

// create
public func createDatabase (_ databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
	return SessionManager.default.createDatabase(databaseId, callback: callback)
}

// list
public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
	return SessionManager.default.databases(callback: callback)
}

// get
public func database (_ databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
	return SessionManager.default.database(databaseId, callback: callback)
}

// delete
public func delete (_ resource: ADDatabase, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, callback: callback)
}




// MARK: - DocumentCollection

//create
public func createDocumentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
	return SessionManager.default.createDocumentCollection(databaseId, collectionId: collectionId, callback: callback)
}

// list
public func documentCollections (_ databaseId: String, callback: @escaping (ADListResponse<ADDocumentCollection>) -> ()) {
	return SessionManager.default.documentCollections(databaseId, callback: callback)
}

// get
public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
	return SessionManager.default.documentCollection(databaseId, collectionId: collectionId, callback: callback)
}

//delete
public func delete (_ resource: ADDocumentCollection, databaseId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, callback: callback)
}

// replace




// MARK: - Document

// create
public func createDocument<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.createDocument(databaseId, collectionId: collectionId, document: document, callback: callback)
}

// list
public func documents<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, callback: @escaping (ADListResponse<T>) -> ()) {
	return SessionManager.default.documents(documentType, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// get
public func document<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.document(documentType, databaseId: databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// delete
public func delete (_ resource: ADDocument, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace
public func replace<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.replace(databaseId, collectionId: collectionId, document: document, callback: callback)
}

// query




// MARK: - Attachments

// create

// list
public func attachments (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
	return SessionManager.default.attachments(databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// delete
public func delete (_ resource: ADAttachment, databaseId: String, collectionId: String, documentId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// replace




// MARK: - Stored Procedures

// create

// list
public func storedProcedures (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
	return SessionManager.default.storedProcedures(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADStoredProcedure, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace

// execute




// MARK: - User Defined Functions

// create

// list
public func userDefinedFunctions (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
	return SessionManager.default.userDefinedFunctions(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADUserDefinedFunction, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace




// MARK: - Triggers

// create

// list
public func triggers (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
	return SessionManager.default.triggers(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADTrigger, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace




// MARK: - Users

// create
public func createUser (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
	return SessionManager.default.createUser(databaseId, userId: userId, callback: callback)
}

// list
public func users (_ databaseId: String, callback: @escaping (ADListResponse<ADUser>) -> ()) {
	return SessionManager.default.users(databaseId, callback: callback)
}

// get
public func user (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
	return SessionManager.default.user(databaseId, userId: userId, callback: callback)
}

// delete
public func delete (_ resource: ADUser, databaseId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, callback: callback)
}

// replace




// MARK: - Permissions

// create

// list
public func permissions (_ databaseId: String, userId: String, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
	return SessionManager.default.permissions(databaseId, userId: userId, callback: callback)
}

// get
public func permission (_ databaseId: String, userId: String, permissionId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
	return SessionManager.default.permission(databaseId, userId: userId, permissionId: permissionId, callback: callback)
}

// delete
public func delete (_ resource: ADPermission, databaseId: String, userId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, userId: userId, callback: callback)
}

// replace




// MARK: - Offers

// list
public func offers (callback: @escaping (ADListResponse<ADOffer>) -> ()) {
	return SessionManager.default.offers(callback: callback)
}

// get
public func offer (_ offerId: String, callback: @escaping (ADResponse<ADOffer>) -> ()) {
	return SessionManager.default.offer(offerId, callback: callback)
}

// replace
// query












