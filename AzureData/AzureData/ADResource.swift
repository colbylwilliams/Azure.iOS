//
//  ADResource.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADResource {
	
	let idKey = 						"id"
	let resourceIdKey = 				"_rid"
	let selfLinkKey = 					"_self"
	let etagKey = 						"_etag"
	let timestampKey = 					"_ts"

	public var id: 						String = ""
	public var resourceId: 				String = ""
	public var selfLink: 				String = ""
	public var etag: 					String = ""
	public var timestamp: 				Date?
	
	required public init(fromJson dict: [String:Any]) {
		// for i in dict { print(i) }
		
		if let id = dict[idKey] as? String {
			self.id = id
		}
		if let resourceId = dict[resourceIdKey] as? String {
			self.resourceId = resourceId
		}
		if let selfLink = dict[selfLinkKey] as? String {
			self.selfLink = selfLink
		}
		if let etag = dict[etagKey] as? String {
			self.etag = etag
		}
		if let timestamp = dict[timestampKey] as? Double {
			self.timestamp = Date(timeIntervalSince1970: timestamp)
		}
	}

	public func printPretty() {
		print("\tid: \(id)")
		print("\tresourceId: \(resourceId)")
		print("\tselfLink: \(selfLink)")
		print("\tetag: \(etag)")
		print("\ttimestamp: \(timestamp?.description ?? "")")
	}
}


public class ADDatabase: ADResource {
	
	let collectionsLinkKey = 			"_colls"
	let usersLinkKey = 					"_users"
	
	public var collectionsLink: 		String = ""
	public var usersLink: 				String = ""
	
	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		if let collectionsLink = dict[collectionsLinkKey] as? String {
			self.collectionsLink = collectionsLink
		}
		if let usersLink = dict[usersLinkKey] as? String {
			self.usersLink = usersLink
		}
	}

	public override func printPretty() {
		print("ADDatabase")
		super.printPretty()
		print("\tcollectionsLink: \(collectionsLink)")
		print("\tcollectionsLink: \(usersLink)")
	}
}


public class ADDocument: ADResource {
	
	let attachmentsLinkKey 				= "_attachments"
	let timeToLiveKey 					= ""
	
	public var attachmentsLink: 		String = ""
	public var timeToLive: 				String = ""
	
	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)

		if let attachmentsLink = dict[attachmentsLinkKey] as? String {
			self.attachmentsLink = attachmentsLink
		}
		if let timeToLive = dict[timeToLiveKey] as? String {
			self.timeToLive = timeToLive
		}
	}

	public override func printPretty() {
		print("ADDocument")
		super.printPretty()
		print("\tattachmentsLink: \(attachmentsLink)")
		print("\ttimeToLive: \(timeToLive)")
	}
}


public class ADDocumentCollection: ADResource {
	
	let conflictsLinkKey 				= "_conflicts"
	let documentsLinkKey 				= "_docs"
	let indexingPolicyKey 				= "indexingPolicy"
	let partitionKeyKey					= "partitionKey"
	let storedProceduresLinkKey 		= "_sprocs"
	let triggersLinkKey 				= "_triggers"
	let userDefinedFunctionsLinkKey 	= "_udfs"

	public var conflictsLink: 			String = ""
	public var documentsLink: 			String = ""
	public var indexingPolicy: 			String = ""
	public var partitionKey: 			String = ""
	public var storedProceduresLink: 	String = ""
	public var triggersLink: 			String = ""
	public var userDefinedFunctionsLink:String = ""

	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		if let conflictsLink = dict[conflictsLinkKey] as? String {
			self.conflictsLink = conflictsLink
		}
		if let documentsLink = dict[documentsLinkKey] as? String {
			self.documentsLink = documentsLink
		}
		if let indexingPolicy = dict[indexingPolicyKey] as? String {
			self.indexingPolicy = indexingPolicy
		}
		if let partitionKey = dict[partitionKeyKey] as? String {
			self.partitionKey = partitionKey
		}
		if let storedProceduresLink = dict[storedProceduresLinkKey] as? String {
			self.storedProceduresLink = storedProceduresLink
		}
		if let triggersLink = dict[triggersLinkKey] as? String {
			self.triggersLink = triggersLink
		}
		if let userDefinedFunctionsLink = dict[userDefinedFunctionsLinkKey] as? String {
			self.userDefinedFunctionsLink = userDefinedFunctionsLink
		}
	}

	public override func printPretty() {
		print("ADDocumentCollection")
		super.printPretty()
		print("\tconflictsLink: \(conflictsLink)")
		print("\tdocumentsLink: \(documentsLink)")
		print("\tindexingPolicy: \(indexingPolicy)")
		print("\tpartitionKey: \(partitionKey)")
		print("\tstoredProceduresLink: \(storedProceduresLink)")
		print("\ttriggersLink: \(triggersLink)")
		print("\tuserDefinedFunctionsLink: \(userDefinedFunctionsLink)")
	}
}

public class ADAttachment: ADResource {
	public var contentType: 			String = ""
	public var mediaLink: 				String = ""
}

public class ADConflict: ADResource {
	public var operationKind: 			String = ""
	public var resourceType: 			String = ""
	public var sourceResourceId:		String = ""
}

public class ADDatabaseAccount: ADResource {
	public var consistencyPolicy: 		String = ""
	public var databasesLink: 			String = ""
	public var maxMediaStorageUsageInMB:String = ""
	public var mediaLink: 				String = ""
	public var mediaStorageUsageInMB: 	String = ""
	public var readableLocations: 		String = ""
	public var writableLocation: 		String = ""
}

public class ADError: ADResource {
	public var code: 					String = ""
	public var message:					String = ""
}

public class ADOffer: ADResource {
	public var offerType: 				String = ""
	public var offerVersion:			String = ""
	public var resourceLink:			String = ""
}

public class ADPartitionKeyRange: ADResource {
	public var parents: 				String = ""
}

public class ADPermissions: ADResource {
	public var permissionMode: 			String = ""
	public var resourceLink: 			String = ""
	public var resourcePartitionKey:	String = ""
	public var token: 					String = ""
}

public class ADStoredProcedure: ADResource {
	public var body: 					String = ""
}

public class ADTrigger: ADResource {
	public var body: 					String = ""
	public var triggerOpertation:		String = ""
	public var triggerType: 			String = ""
}

public class ADUser: ADResource {
	public var permissionsLink: 		String = ""
}

public class ADUserDefinedFunction: ADResource {
	public var body: 					String = ""
}

public enum ADResourceType : String {
	case database				= "dbs"
	case user					= "users"
	case permission				= "permissions"
	case collection				= "colls"
	case storedProcedure		= "sprocs"
	case trigger				= "triggers"
	case udf					= "udfs"
	case document				= "docs"
	case attachment				= "attachments"
	case offer					= "offers"
	
	var path: String {
		switch self {
		case .database: 		return "dbs"
		case .user: 			return "users"
		case .permission: 		return "permissions"
		case .collection: 		return "colls"
		case .storedProcedure: 	return "sprocs"
		case .trigger: 			return "triggers"
		case .udf: 				return "udfs"
		case .document: 		return "docs"
		case .attachment: 		return "attachments"
		case .offer: 			return "offers"
		}
	}
}

// https://docs.microsoft.com/en-us/rest/api/documentdb/documentdb-resource-uri-syntax-for-rest
public struct ADResourceUri {
	
	let baseUri: String
	
	init(_ databaseaccount: String) {
		baseUri = "https://\(databaseaccount).documents.azure.com"
	}
	
	func database(_ databaseId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func user(_ databaseId: String, userId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/users/\(userId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func permission(_ databaseId: String, userId: String, permissionId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/users/\(userId)/permissions/\(permissionId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func collection(_ databaseId: String, collectionId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func storedProcedure(_ databaseId: String, collectionId: String, storedProcedureId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)/sprocs/\(storedProcedureId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func trigger(_ databaseId: String, collectionId: String, triggerId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)/triggers/\(triggerId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func udf(_ databaseId: String, collectionId: String, udfId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)/udfs/\(udfId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func document(_ databaseId: String, collectionId: String, documentId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)/docs/\(documentId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func attachment(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String) -> (URL, String) {
		let link = "dbs/\(databaseId)/colls/\(collectionId)/docs/\(documentId)/attachments/\(attachmentId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
	
	func offer(_ offerId: String) -> (URL, String) {
		let link = "offers/\(offerId)"
		return (URL(string:"\(baseUri)/\(link)")!, link)
	}
} 
