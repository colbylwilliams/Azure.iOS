//
//  AzureData.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation


public func isSetup() -> Bool { return SessionManager.default.setup }

// setup
public func setup (_ name: String, key: String, keyType: ADTokenType = .master, verboseLogging: Bool = false) {
    return SessionManager.default.setup(name, key: key, keyType: keyType, verboseLogging: verboseLogging)
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




// MARK: - Collection

//create
public func createCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
	return SessionManager.default.createCollection(databaseId, collectionId: collectionId, callback: callback)
}

// list
public func collections (_ databaseId: String, callback: @escaping (ADListResponse<ADCollection>) -> ()) {
	return SessionManager.default.collections(databaseId, callback: callback)
}

// get
public func collection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
	return SessionManager.default.collection(databaseId, collectionId: collectionId, callback: callback)
}

//delete
public func delete (_ resource: ADCollection, databaseId: String, callback: @escaping (Bool) -> ()) {
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
public func query (_ databaseId: String, collectionId: String, query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
	return SessionManager.default.query(databaseId, collectionId: collectionId, query: query, callback: callback)
}



// MARK: - Attachments

// create
public func createAttachment(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaUrl: URL, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.createAttachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaUrl: mediaUrl, callback: callback)
}

public func createAttachment(_ databaseId: String, collectionId: String, documentId: String, contentType: String, mediaName: String, media:Data, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.createAttachment(databaseId, collectionId: collectionId, documentId: documentId, contentType: contentType, mediaName: mediaName, media: media, callback: callback)
}

// list
public func attachments (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
	return SessionManager.default.attachments(databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// delete
public func delete (_ resource: ADAttachment, databaseId: String, collectionId: String, documentId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, documentId: documentId, callback: callback)
}

// replace
public func replace(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaUrl: URL, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    SessionManager.default.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaUrl: mediaUrl, callback: callback)
}

public func replace(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaName: String, media:Data, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    SessionManager.default.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaName: mediaName, media: media, callback: callback)
}




// MARK: - Stored Procedures

// create
public func createStoredProcedure (_ databaseId: String, collectionId: String, storedProcedureId: String, body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
	return SessionManager.default.createStoredProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, body: body, callback: callback)
}

// list
public func storedProcedures (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
	return SessionManager.default.storedProcedures(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADStoredProcedure, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace
public func replace (_ databaseId: String, collectionId: String, storedProcedureId: String, body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
	return SessionManager.default.replace(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, body: body, callback: callback)
}

// execute
public func execute (_ databaseId: String, collectionId: String, storedProcedureId: String, parameters: [String]?, callback: @escaping (Data?) -> ()) {
	return SessionManager.default.execute(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, parameters: parameters, callback: callback)
}



// MARK: - User Defined Functions

// create
public func createUserDefinedFunction (_ databaseId: String, collectionId: String, functionId: String, body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
	return SessionManager.default.createUserDefinedFunction(databaseId, collectionId: collectionId, functionId: functionId, body: body, callback: callback)
}

// list
public func userDefinedFunctions (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
	return SessionManager.default.userDefinedFunctions(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADUserDefinedFunction, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace
public func replace (_ databaseId: String, collectionId: String, functionId: String, body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
	return SessionManager.default.replace(databaseId, collectionId: collectionId, functionId: functionId, body: body, callback: callback)
}



// MARK: - Triggers

// create
public func createTrigger (_ databaseId: String, collectionId: String, triggerId: String, triggerBody: String, operation: ADTriggerOperation, triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
	return SessionManager.default.createTrigger(databaseId, collectionId: collectionId, triggerId: triggerId, triggerBody: triggerBody, operation: operation, triggerType: triggerType, callback: callback)
}

// list
public func triggers (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
	return SessionManager.default.triggers(databaseId, collectionId: collectionId, callback: callback)
}

// delete
public func delete (_ resource: ADTrigger, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, databaseId: databaseId, collectionId: collectionId, callback: callback)
}

// replace
public func replace (_ databaseId: String, collectionId: String, triggerId: String, triggerBody: String, operation: ADTriggerOperation, triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
	return SessionManager.default.replace(databaseId, collectionId: collectionId, triggerId: triggerId, triggerBody: triggerBody, operation: operation, triggerType: triggerType, callback: callback)
}



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
public func replace (_ databaseId: String, userId: String, newUserId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
	return SessionManager.default.replace(databaseId, userId: userId, newUserId: newUserId, callback: callback)
}



// MARK: - Permissions

// create
public func createPermission (_ resource: ADResource, databaseId: String, userId: String, permissionId: String, permissionMode: ADPermissionMode, callback: @escaping (ADResponse<ADPermission>) -> ()) {
	SessionManager.default.createPermission(resource, databaseId: databaseId, userId: userId, permissionId: permissionId, permissionMode: permissionMode, callback: callback)
}

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
public func replace (_ databaseId: String, userId: String, permissionId: String,  permissionMode: ADPermissionMode, resource: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
	return SessionManager.default.replace(databaseId, userId: userId, permissionId: permissionId, permissionMode: permissionMode, resource: resource, callback: callback)
}



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












