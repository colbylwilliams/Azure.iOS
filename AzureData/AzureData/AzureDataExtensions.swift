//
//  AzureDataExtensions.swift
//  AzureData
//
//  Created by Colby Williams on 10/24/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation


public extension ADDatabase {
    
    // MARK - Document Collection
    
    //create
    public func create (collectionWithId id: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
		return SessionManager.default.create(collectionWithId: id, inDatabase: self.id, callback: callback)
    }
    
    // list
    public func getCollections (callback: @escaping (ADListResponse<ADCollection>) -> ()) {
		return SessionManager.default.get(collectionsIn: self.id, callback: callback)
    }
    
    // get
    public func get (collectionWithId collectionId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
		return SessionManager.default.get(collectionWithId: collectionId, inDatabase: self.id, callback: callback)
    }
    
    //delete
    public func delete (collection resource: ADCollection, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, fromDatabase: self.id, callback: callback)
    }
    
    
    
    // MARK - Users
    
    //create
    public func create (userWithId id: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
        return SessionManager.default.create (userWithId: id, inDatabase: self.id, callback: callback)
    }
    
    // list
    public func getUsers (callback: @escaping (ADListResponse<ADUser>) -> ()) {
        return SessionManager.default.get (usersIn: self.id, callback: callback)
    }
    
    // get
    public func get (userWithId id: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
        return SessionManager.default.get (userWithId: id, inDatabase: self.id, callback: callback)
    }
    
    //delete
    public func delete (_ user: ADUser, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete (user, fromDatabase: self.id, callback: callback)
    }
	
	// replace
	public func replace (userWithId id: String, with newUserId: String, in databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		return SessionManager.default.replace (userWithId: id, with: newUserId, inDatabase: databaseId, callback: callback)
	}
}


public extension ADCollection {
	
    // MARK - Documents
    
    // create
    public func create<T: ADDocument> (_ document: T, callback: @escaping (ADResponse<T>) -> ()) {
		return SessionManager.default.create(document, in: self, callback: callback)
    }
    
    // list
    public func get<T: ADDocument> (documentsAs documentType:T.Type, callback: @escaping (ADListResponse<T>) -> ()) {
		return SessionManager.default.get(documentsAs: documentType, in: self, callback: callback)
    }
    
    // get
    public func get<T: ADDocument> (documentWithResourceId id: String, as documentType:T.Type, callback: @escaping (ADResponse<T>) -> ()) {
		return SessionManager.default.get(documentWithId: id, as: documentType, in: self, callback: callback)
    }
    
    // delete
    public func delete (_ document: ADDocument, callback: @escaping (Bool) -> ()) {
		return SessionManager.default.delete(document, from: self, callback: callback)
    }
    
    // replace
    public func replace<T: ADDocument> (_ document: T, callback: @escaping (ADResponse<T>) -> ()) {
		return SessionManager.default.replace(document, in: self, callback: callback)
    }
    
    // query
	public func query (documentsWith query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
		return SessionManager.default.query(documentsIn: self, with: query, callback: callback)
    }
    
    
    
    // MARK: - Stored Procedures
    
    // create
    public func create (storedProcedureWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
		return SessionManager.default.create (storedProcedureWithId: id, andBody: body, in: self, callback: callback)
    }
    
    // list
    public func getStoredProcedures (callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
		return SessionManager.default.get (storedProceduresIn: self, callback: callback)
    }
    
    // delete
    public func delete (_ storedProcedure: ADStoredProcedure, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete (storedProcedure, from: self, callback: callback)
    }
    
    // replace
    public func replace (storedProcedureWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        return SessionManager.default.replace (storedProcedureWithId: id, andBody: body, in: self, callback: callback)
    }
    
    // execute
    public func execute (storedProcedureWithId id: String, usingParameters parameters: [String]?, callback: @escaping (Data?) -> ()) {
        return SessionManager.default.execute (storedProcedureWithId: id, usingParameters: parameters, in: self, callback: callback)
    }
    
    
    
    // MARK: - User Defined Functions
    
    // create
    public func create (userDefinedFunctionWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.create (userDefinedFunctionWithId: id, andBody: body, in: self, callback: callback)
    }
    
    // list
    public func getUserDefinedFunctions (callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.get (userDefinedFunctionsIn: self, callback: callback)
    }
    
    // delete
    public func delete (_ userDefinedFunction: ADUserDefinedFunction, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete (userDefinedFunction, from: self, callback: callback)
    }
    
    // replace
    public func replace (userDefinedFunctionWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.replace (userDefinedFunctionWithId: id, andBody: body, from: self, callback: callback)
    }
    
    
    
    // MARK: - Triggers
    
    // create
    public func create (triggerWithId id: String, operation: ADTriggerOperation, type: ADTriggerType, andBody body: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return SessionManager.default.create (triggerWithId: id, operation: operation, type: type, andBody: body, in: self, callback: callback)
    }
    
    // list
    public func getTriggers (callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
        return SessionManager.default.get (triggersIn: self, callback: callback)
    }
    
    // delete
    public func delete (_ trigger: ADTrigger, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete (trigger, from: self, callback: callback)
    }
    
    // replace
    public func replace (triggerWithId id: String, operation: ADTriggerOperation, type: ADTriggerType, andBody body: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return SessionManager.default.replace (triggerWithId: id, operation: operation, type: type, andBody: body, in: self, callback: callback)
    }
}


public extension ADDocument {
    
}











