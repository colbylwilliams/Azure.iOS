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



// MARK: - Databases

// create
public func create (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
	return SessionManager.default.create(databaseWithId: databaseId, callback: callback)
}

// list
public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
	return SessionManager.default.databases(callback: callback)
}

// get
public func get (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
	return SessionManager.default.get(databaseWithId: databaseId, callback: callback)
}

// delete
public func delete (_ resource: ADDatabase, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, callback: callback)
}



// MARK: - Collections

// create
public func create (collectionWithId collectionId: String, in databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
	return SessionManager.default.create(collectionWithId: collectionId, in: databaseId, callback: callback)
}

// list
public func get (collectionsIn databaseId: String, callback: @escaping (ADListResponse<ADCollection>) -> ()) {
	return SessionManager.default.get(collectionsIn: databaseId, callback: callback)
}

// get
public func get (collectionWithId collectionId: String, in databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
	return SessionManager.default.get(collectionWithId: collectionId, in: databaseId, callback: callback)
}

// delete
public func delete (_ resource: ADCollection, from databaseId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(resource, from: databaseId, callback: callback)
}

// replace




// MARK: - Documents

// create
public func create<T: ADDocument> (_ document: T, inCollection collectionId: String, in databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.create(document, inCollection: collectionId, in: databaseId, callback: callback)
}

public func create<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.create(document, in: collection, callback: callback)
}


// list
public func get<T: ADDocument> (documentsAs documentType: T.Type, inCollection collectionId: String, in databaseId: String, callback: @escaping (ADListResponse<T>) -> ()) {
	return SessionManager.default.get(documentsAs: documentType, inCollection: collectionId, in: databaseId, callback: callback)
}

public func get<T: ADDocument> (documentsAs documentType: T.Type, in collection: ADCollection, callback: @escaping (ADListResponse<T>) -> ()) {
	return SessionManager.default.get(documentsAs: documentType, in: collection, callback: callback)
}


// get
public func get<T: ADDocument> (documentWithId documentId: String, as documentType:T.Type, inCollection collectionId: String, in databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.get(documentWithId: documentId, as: documentType, inCollection: collectionId, in: databaseId, callback: callback)
}

public func get<T: ADDocument> (documentWithId resourceId: String, as documentType:T.Type, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.get(documentWithId: resourceId, as: documentType, in: collection, callback: callback)
}


// delete
public func delete (_ document: ADDocument, fromCollection collectionId: String, in databaseId: String, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(document, fromCollection: collectionId, in: databaseId, callback: callback)
}

public func delete (_ document: ADDocument, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
	return SessionManager.default.delete(document, from: collection, callback: callback)
}


// replace
public func replace<T: ADDocument> (_ document: T, inCollection collectionId: String, in databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.replace(document, inCollection: collectionId, in: databaseId, callback: callback)
}

public func replace<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
	return SessionManager.default.replace(document, in: collection, callback: callback)
}


// query
public func query (documentsIn collectionId: String, in databaseId: String, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
	return SessionManager.default.query(documentsIn: collectionId, in: databaseId, with: query, callback: callback)
}

public func query (documentsIn collection: ADCollection, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
	return SessionManager.default.query(documentsIn: collection, with: query, callback: callback)
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
    return SessionManager.default.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaUrl: mediaUrl, callback: callback)
}

public func replace(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaName: String, media:Data, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaName: mediaName, media: media, callback: callback)
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












