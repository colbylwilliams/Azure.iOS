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
    public func create (collectionWithId id: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
        return SessionManager.default.createDocumentCollection(self.id, collectionId: id, callback: callback)
    }
    
    // list
    public func getCollections (callback: @escaping (ADListResponse<ADDocumentCollection>) -> ()) {
        return SessionManager.default.documentCollections(self.id, callback: callback)
    }
    
    // get
    public func get (collectionWithId id: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
        return SessionManager.default.documentCollection(self.id, collectionId: id, callback: callback)
    }
    
    //delete
    public func delete (collection resource: ADDocumentCollection, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, databaseId: self.id, callback: callback)
    }
    
    
    
    // MARK - Users
    
    //create
    public func create (userWithId id: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
        return SessionManager.default.createUser(self.id, userId: id, callback: callback)
    }
    
    // list
    public func getUsers (callback: @escaping (ADListResponse<ADUser>) -> ()) {
        return SessionManager.default.users(self.id, callback: callback)
    }
    
    // get
    public func get (userWithId id: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
        return SessionManager.default.user(self.id, userId: id, callback: callback)
    }
    
    //delete
    public func delete (user resource: ADUser, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, databaseId: self.id, callback: callback)
    }
}

public extension ADDocumentCollection {
	
    // MARK - Documents
    
    // create
    public func create<T: ADDocument> (document resource: T, callback: @escaping (ADResponse<T>) -> ()) {
        return SessionManager.default.createDocument(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // list
    public func get<T: ADDocument> (documentsAs documentType:T.Type, callback: @escaping (ADListResponse<T>) -> ()) {
        return SessionManager.default.documents(atSelfLink: self.selfLink!, as: documentType, callback: callback)
    }
    
    // get
    public func get<T: ADDocument> (documentWithResourceId id: String, as documentType:T.Type, callback: @escaping (ADResponse<T>) -> ()) {
        return SessionManager.default.document(withResourceId: id, atSelfLink: self.selfLink!, as: documentType, callback: callback)
    }
    
    // delete
    public func delete (document resource: ADDocument, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // replace
    public func replace<T: ADDocument> (document resource: T, callback: @escaping (ADResponse<T>) -> ()) {
        return SessionManager.default.replace(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // query
    public func query (documentsWith query:ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
        return SessionManager.default.query(query, atSelfLink: self.selfLink!, callback: callback)
    }
    
    
    
    // MARK: - Stored Procedures
    
    // create
    public func create (storedProcedureWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        return SessionManager.default.createStoredProcedure(withId: id, andBody: body, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // list
    public func getStoredProcedures (callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
        return SessionManager.default.storedProcedures(atSelfLink: self.selfLink!, callback: callback)
    }
    
    // delete
    public func delete (_ resource: ADStoredProcedure, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // replace
    public func replace (storedProcedureWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        return SessionManager.default.replace(storedProcedureWithId: id, andBody: body, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // execute
    public func execute (storedProcedureWithId id: String, usingParameters parameters: [String]?, callback: @escaping (Data?) -> ()) {
        return SessionManager.default.execute(storedProcedureWithId: id, atSelfLink: self.selfLink!, usingParameters: parameters, callback: callback)
    }
    
    
    
    // MARK: - User Defined Functions
    
    // create
    public func create (userDefinedFunctionWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.createUserDefinedFunction(withId: id, andBody: body, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // list
    public func getUserDefinedFunctions (callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.userDefinedFunctions(atSelfLink: self.selfLink!, callback: callback)
    }
    
    // delete
    public func delete (_ resource: ADUserDefinedFunction, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // replace
    public func replace (userDefinedFunctionWithId id: String, andBody body: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        return SessionManager.default.replace(userDefinedFunctionWithId: id, andBody: body, atSelfLink: self.selfLink!, callback: callback)
    }
    
    
    
    // MARK: - Triggers
    
    // create
    public func create (triggerWithId id: String, andBody body: String, operation: ADTriggerOperation, type: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return SessionManager.default.createTrigger(withId: id, andBody: body, operation: operation, type: type, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // list
    public func getTriggers (callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
        return SessionManager.default.triggers(atSelfLink: self.selfLink!, callback: callback)
    }
    
    // delete
    public func delete (_ resource: ADTrigger, callback: @escaping (Bool) -> ()) {
        return SessionManager.default.delete(resource, atSelfLink: self.selfLink!, callback: callback)
    }
    
    // replace
    public func replace (triggerWithId id: String, andBody body: String, operation: ADTriggerOperation, type: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return SessionManager.default.replace(triggerWithId: id, andBody: body, operation: operation, type: type, atSelfLink: self.selfLink!, callback: callback)
    }
}


public extension ADDocument {
    
}











