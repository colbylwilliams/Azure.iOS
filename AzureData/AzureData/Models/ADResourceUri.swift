//
//  ADResourceUri.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

// https://docs.microsoft.com/en-us/rest/api/documentdb/documentdb-resource-uri-syntax-for-rest
public struct ADResourceUri {
	let empty = ""
	
	let baseUri: String
	
	init(_ databaseaccount: String) {
		baseUri = "https://\(databaseaccount).documents.azure.com"
	}
	
	func database(_ databaseId: String? = nil) -> (URL, String) {
		let noId = databaseId == nil || databaseId!.isEmpty
		let fragment = noId ? empty : "/\(databaseId!)"
		let baseLink = ""
		let itemLink = "dbs\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func user(_ databaseId: String, userId: String? = nil) -> (URL, String) {
		let noId = userId == nil || userId!.isEmpty
		let fragment = noId ? empty : "/\(userId!)"
		let baseLink = "dbs/\(databaseId)"
		let itemLink = "\(baseLink)/users\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func permission(_ databaseId: String, userId: String, permissionId: String? = nil) -> (URL, String) {
		let noId = permissionId == nil || permissionId!.isEmpty
		let fragment = noId ? empty : "/\(permissionId!)"
		let baseLink = "dbs/\(databaseId)/users/\(userId)"
		let itemLink = "\(baseLink)/permissions\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func collection(_ databaseId: String, collectionId: String? = nil) -> (URL, String) {
		let noId = collectionId == nil || collectionId!.isEmpty
		let fragment = noId ? empty : "/\(collectionId!)"
		let baseLink = "dbs/\(databaseId)"
		let itemLink = "\(baseLink)/colls\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func storedProcedure(_ databaseId: String, collectionId: String, storedProcedureId: String? = nil) -> (URL, String) {
		let noId = storedProcedureId == nil || storedProcedureId!.isEmpty
		let fragment = noId ? empty : "/\(storedProcedureId!)"
		let baseLink = "dbs/\(databaseId)/colls/\(collectionId)"
		let itemLink = "\(baseLink)/sprocs\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func trigger(_ databaseId: String, collectionId: String, triggerId: String? = nil) -> (URL, String) {
		let noId = triggerId == nil || triggerId!.isEmpty
		let fragment = noId ? empty : "/\(triggerId!)"
		let baseLink = "dbs/\(databaseId)/colls/\(collectionId)"
		let itemLink = "\(baseLink)/triggers\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func udf(_ databaseId: String, collectionId: String, udfId: String? = nil) -> (URL, String) {
		let noId = udfId == nil || udfId!.isEmpty
		let fragment = noId ? empty : "/\(udfId!)"
		let baseLink = "dbs/\(databaseId)/colls/\(collectionId)"
		let itemLink = "\(baseLink)/udfs\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func document(_ databaseId: String, collectionId: String, documentId: String? = nil) -> (URL, String) {
		let noId = documentId == nil || documentId!.isEmpty
		let fragment = noId ? empty : "/\(documentId!)"
		let baseLink = "dbs/\(databaseId)/colls/\(collectionId)"
		let itemLink = "\(baseLink)/docs\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func attachment(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String? = nil) -> (URL, String) {
		let noId = attachmentId == nil || attachmentId!.isEmpty
		let fragment = noId ? empty : "/\(attachmentId!)"
		let baseLink = "dbs/\(databaseId)/colls/\(collectionId)/docs/\(documentId)"
		let itemLink = "\(baseLink)/attachments\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
	
	func offer(_ offerId: String? = nil) -> (URL, String) {
		let noId = offerId == nil || offerId!.isEmpty
		let fragment = noId ? empty : "/\(offerId!)"
		let baseLink = ""
		let itemLink = "offers\(fragment)"
		return (URL(string:"\(baseUri)/\(itemLink)")!, noId ? baseLink : itemLink)
	}
}
