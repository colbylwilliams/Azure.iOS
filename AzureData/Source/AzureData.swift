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
    return SessionManager.default.setup (name, key: key, keyType: keyType, verboseLogging: verboseLogging)
}

public func reset () {
    return SessionManager.default.reset()
}


// MARK: - Databases

// create
public func create (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
    return SessionManager.default.create (databaseWithId: databaseId, callback: callback)
}

// list
public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
    return SessionManager.default.databases (callback: callback)
}

// get
public func get (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
    return SessionManager.default.get (databaseWithId: databaseId, callback: callback)
}

// delete
public func delete (_ database: ADDatabase, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (database, callback: callback)
}



// MARK: - Collections

// create
public func create (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
    return SessionManager.default.create (collectionWithId: collectionId, inDatabase: databaseId, callback: callback)
}

// list
public func get (collectionsIn databaseId: String, callback: @escaping (ADListResponse<ADCollection>) -> ()) {
    return SessionManager.default.get (collectionsIn: databaseId, callback: callback)
}

// get
public func get (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
    return SessionManager.default.get (collectionWithId: collectionId, inDatabase: databaseId, callback: callback)
}

// delete
public func delete (_ collection: ADCollection, fromDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (collection, fromDatabase: databaseId, callback: callback)
}

// replace




// MARK: - Documents

// create
public func create<T: ADDocument> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.create (document, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.create (document, in: collection, callback: callback)
}


// list
public func get<T: ADDocument> (documentsAs documentType: T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<T>) -> ()) {
    return SessionManager.default.get (documentsAs: documentType, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func get<T: ADDocument> (documentsAs documentType: T.Type, in collection: ADCollection, callback: @escaping (ADListResponse<T>) -> ()) {
    return SessionManager.default.get (documentsAs: documentType, in: collection, callback: callback)
}


// get
public func get<T: ADDocument> (documentWithId documentId: String, as documentType:T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.get (documentWithId: documentId, as: documentType, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func get<T: ADDocument> (documentWithId documentId: String, as documentType:T.Type, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.get (documentWithId: documentId, as: documentType, in: collection, callback: callback)
}


// delete
public func delete (_ document: ADDocument, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (document, fromCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func delete (_ document: ADDocument, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (document, from: collection, callback: callback)
}


// replace
public func replace<T: ADDocument> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.replace (document, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
    return SessionManager.default.replace (document, in: collection, callback: callback)
}


// query
public func query (documentsIn collectionId: String, inDatabase databaseId: String, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
    return SessionManager.default.query (documentsIn: collectionId, inDatabase: databaseId, with: query, callback: callback)
}

public func query (documentsIn collection: ADCollection, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
    return SessionManager.default.query (documentsIn: collection, with: query, callback: callback)
}




// MARK: - Attachments

// create
public func create (attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.create (attachmentWithId: attachmentId, contentType: contentType, andMediaUrl: mediaUrl, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create (attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.create (attachmentWithId: attachmentId, contentType: contentType, name: mediaName, with: media, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create (attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument document: ADDocument, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.create (attachmentWithId: attachmentId, contentType: contentType, andMediaUrl: mediaUrl, onDocument: document, callback: callback)
}

public func create (attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument document: ADDocument, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.create (attachmentWithId: attachmentId, contentType: contentType, name: mediaName, with: media, onDocument: document, callback: callback)
}

// list
public func get (attachmentsOn documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
    return SessionManager.default.get (attachmentsOn: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func get (attachmentsOn document: ADDocument, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
    return SessionManager.default.get (attachmentsOn: document, callback: callback)
}

// delete
public func delete (_ attachment: ADAttachment, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (attachment, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func delete (_ attachment: ADAttachment, onDocument document: ADDocument, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (attachment, onDocument: document, callback: callback)
}

// replace
public func replace (attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.replace (attachmentWithId: attachmentId, contentType: contentType, andMediaUrl: mediaUrl, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace (attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.replace (attachmentWithId: attachmentId, contentType: contentType, name: mediaName, with: media, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace (attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument document: ADDocument, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.replace (attachmentWithId: attachmentId, contentType: contentType, andMediaUrl: mediaUrl, onDocument: document, callback: callback)
}

public func replace (attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument document: ADDocument, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
    return SessionManager.default.replace (attachmentWithId: attachmentId, contentType: contentType, name: mediaName, with: media, onDocument: document, callback: callback)
}


// MARK: - Stored Procedures

// create
public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.create (storedProcedureWithId: storedProcedureId, andBody: procedure, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: ADCollection, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.create (storedProcedureWithId: storedProcedureId, andBody: procedure, in: collection, callback: callback)
}

// list
public func get (storedProceduresIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.get (storedProceduresIn: collectionId, inDatabase: databaseId, callback: callback)
}

public func get (storedProceduresIn collection: ADCollection, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.get (storedProceduresIn: collection, callback: callback)
}

// delete
public func delete (_ storedProcedure: ADStoredProcedure, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (storedProcedure, fromCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func delete (_ storedProcedure: ADStoredProcedure, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (storedProcedure, from: collection, callback: callback)
}

// replace
public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.replace (storedProcedureWithId: storedProcedureId, andBody: procedure, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: ADCollection, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
    return SessionManager.default.replace (storedProcedureWithId: storedProcedureId, andBody: procedure, in: collection, callback: callback)
}

// execute
public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Data?) -> ()) {
    return SessionManager.default.execute (storedProcedureWithId: storedProcedureId, usingParameters: parameters, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, in collection: ADCollection, callback: @escaping (Data?) -> ()) {
    return SessionManager.default.execute (storedProcedureWithId: storedProcedureId, usingParameters: parameters, in: collection, callback: callback)
}




// MARK: - User Defined Functions

// create
public func create (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.create (userDefinedFunctionWithId: functionId, andBody: function, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create (userDefinedFunctionWithId functionId: String, andBody function: String, in collection: ADCollection, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.create (userDefinedFunctionWithId: functionId, andBody: function, in: collection, callback: callback)
}

// list
public func get (userDefinedFunctionsIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.get (userDefinedFunctionsIn: collectionId, inDatabase: databaseId, callback: callback)
}

public func get (userDefinedFunctionsIn collection: ADCollection, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.get (userDefinedFunctionsIn: collection, callback: callback)
}

// delete
public func delete (_ userDefinedFunction: ADUserDefinedFunction, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (userDefinedFunction, fromCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func delete (_ userDefinedFunction: ADUserDefinedFunction, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (userDefinedFunction, from: collection, callback: callback)
}

// replace
public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.replace (userDefinedFunctionWithId: functionId, andBody: function, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, from collection: ADCollection, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
    return SessionManager.default.replace (userDefinedFunctionWithId: functionId, andBody: function, from: collection, callback: callback)
}




// MARK: - Triggers

// create
public func create (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
    return SessionManager.default.create (triggerWithId: triggerId, operation: operation, type: triggerType, andBody: triggerBody, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func create (triggerWithId triggerId: String, operation: ADTriggerOperation, type: ADTriggerType, andBody triggerBody: String, in collection: ADCollection, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
    return SessionManager.default.create (triggerWithId: triggerId, operation: operation, type: type, andBody: triggerBody, in: collection, callback: callback)
}

// list
public func get (triggersIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
    return SessionManager.default.get (triggersIn: collectionId, inDatabase: databaseId, callback: callback)
}

public func get (triggersIn collection: ADCollection, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
    return SessionManager.default.get (triggersIn: collection, callback: callback)
}

// delete
public func delete (_ trigger: ADTrigger, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (trigger, fromCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func delete (_ trigger: ADTrigger, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (trigger, from: collection, callback: callback)
}

// replace
public func replace (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
    return SessionManager.default.replace (triggerWithId: triggerId, operation: operation, type: triggerType, andBody: triggerBody, inCollection: collectionId, inDatabase: databaseId, callback: callback)
}

public func replace (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, in collection: ADCollection, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
    return SessionManager.default.replace (triggerWithId: triggerId, operation: operation, type: triggerType, andBody: triggerBody, in: collection, callback: callback)
}




// MARK: - Users

// create
public func create (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
    return SessionManager.default.create (userWithId: userId, inDatabase: databaseId, callback: callback)
}

// list
public func get (usersIn databaseId: String, callback: @escaping (ADListResponse<ADUser>) -> ()) {
    return SessionManager.default.get (usersIn: databaseId, callback: callback)
}

// get
public func get (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
    return SessionManager.default.get (userWithId: userId, inDatabase: databaseId, callback: callback)
}

// delete
public func delete (_ user: ADUser, fromDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (user, fromDatabase: databaseId, callback: callback)
}

// replace
public func replace (userWithId userId: String, with newUserId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
    return SessionManager.default.replace (userWithId: userId, with: newUserId, inDatabase: databaseId, callback: callback)
}




// MARK: - Permissions

// create
public func create (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.create (permissionWithId: permissionId, mode: permissionMode, in: resource, forUser: userId, inDatabase: databaseId, callback: callback)
}

public func create (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser user: ADUser, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.create (permissionWithId: permissionId, mode: permissionMode, in: resource, forUser: user, callback: callback)
}

// list
public func get (permissionsFor userId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
    return SessionManager.default.get (permissionsFor: userId, inDatabase: databaseId, callback: callback)
}

public func get (permissionsFor user: ADUser, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
    return SessionManager.default.get (permissionsFor: user, callback: callback)
}

// get
public func get (permissionWithId permissionId: String, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.get (permissionWithId: permissionId, forUser: userId, inDatabase: databaseId, callback: callback)
}

public func get (permissionWithId permissionId: String, forUser user: ADUser, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.get (permissionWithId: permissionId, forUser: user, callback: callback)
}

// delete
public func delete (_ permission: ADPermission, forUser userId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (permission, forUser: userId, inDatabase: databaseId, callback: callback)
}

public func delete (_ permission: ADPermission, forUser user: ADUser, callback: @escaping (Bool) -> ()) {
    return SessionManager.default.delete (permission, forUser: user, callback: callback)
}

// replace
public func replace (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.replace (permissionWithId: permissionId, mode: permissionMode, in: resource, forUser: userId, inDatabase: databaseId, callback: callback)
}

public func replace (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser user: ADUser, callback: @escaping (ADResponse<ADPermission>) -> ()) {
    return SessionManager.default.replace (permissionWithId: permissionId, mode: permissionMode, in: resource, forUser: user, callback: callback)
}



// MARK: - Offers

// list
public func offers (callback: @escaping (ADListResponse<ADOffer>) -> ()) {
    return SessionManager.default.offers (callback: callback)
}

// get
public func get (offerWithId offerId: String, callback: @escaping (ADResponse<ADOffer>) -> ()) {
    return SessionManager.default.get (offerWithId: offerId, callback: callback)
}

// replace

// query











