//
//  ADResourceType.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public enum ADResourceType : String {
    case database               = "dbs"
    case user                   = "users"
    case permission             = "permissions"
    case collection             = "colls"
    case storedProcedure        = "sprocs"
    case trigger                = "triggers"
    case udf                    = "udfs"
    case document               = "docs"
    case attachment             = "attachments"
    case offer                  = "offers"
    
    var path: String {
        switch self {
        case .database:         return "dbs"
        case .user:             return "users"
        case .permission:       return "permissions"
        case .collection:       return "colls"
        case .storedProcedure:  return "sprocs"
        case .trigger:          return "triggers"
        case .udf:              return "udfs"
        case .document:         return "docs"
        case .attachment:       return "attachments"
        case .offer:            return "offers"
        }
    }
    
    var key: String {
        switch self {
        case .database:         return "Databases"
        case .user:             return "Users"
        case .permission:       return "Permissions"
        case .collection:       return "DocumentCollections"
        case .storedProcedure:  return "StoredProcedures"
        case .trigger:          return "Triggers"
        case .udf:              return "UserDefinedFunctions"
        case .document:         return "Documents"
        case .attachment:       return "Attachments"
        case .offer:            return "Offers"
        }
    }

    var name: String {
        switch self {
        case .database:         return "Database"
        case .user:             return "User"
        case .permission:       return "Permission"
        case .collection:       return "DocumentCollection"
        case .storedProcedure:  return "StoredProcedure"
        case .trigger:          return "Trigger"
        case .udf:              return "UserDefinedFunction"
        case .document:         return "Document"
        case .attachment:       return "Attachment"
        case .offer:            return "Offer"
        }
    }

    var type: ADResource.Type {
        switch self {
        case .database:         return ADDatabase.self
        case .user:             return ADUser.self
        case .permission:       return ADPermission.self
        case .collection:       return ADCollection.self
        case .storedProcedure:  return ADStoredProcedure.self
        case .trigger:          return ADTrigger.self
        case .udf:              return ADUserDefinedFunction.self
        case .document:         return ADDocument.self
        case .attachment:       return ADAttachment.self
        case .offer:            return ADOffer.self
        }
    }

    init?(fromResource resource: ADResource) {
        switch resource {
        case is ADDatabase:             self = .database
        case is ADUser:                 self = .user
        case is ADPermission:           self = .permission
        case is ADCollection:           self = .collection
        case is ADStoredProcedure:      self = .storedProcedure
        case is ADTrigger:              self = .trigger
        case is ADUserDefinedFunction:  self = .udf
        case is ADDocument:             self = .document
        case is ADAttachment:           self = .attachment
        case is ADOffer:                self = .offer
        default: return nil
        }
    }
}