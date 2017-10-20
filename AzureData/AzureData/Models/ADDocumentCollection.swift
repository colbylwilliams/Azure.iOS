//
//  ADDocumentCollection.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

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
	public var indexingPolicy: 			ADIndexingPolicy?
	public var partitionKey: 			ADPartitionKeyDefinition?
	public var storedProceduresLink: 	String = ""
	public var triggersLink: 			String = ""
	public var userDefinedFunctionsLink:String = ""
	
	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		if let conflictsLink 			= dict[conflictsLinkKey] 			as? String { self.conflictsLink = conflictsLink }
		if let documentsLink 			= dict[documentsLinkKey] 			as? String { self.documentsLink = documentsLink }
		if let indexingPolicy 			= dict[indexingPolicyKey] 			as? [String:Any] { self.indexingPolicy = ADIndexingPolicy(fromJson: indexingPolicy) }
		if let partitionKey 			= dict[partitionKeyKey] 			as? [String:Any] { self.partitionKey = ADPartitionKeyDefinition(fromJson: partitionKey) }
		if let storedProceduresLink 	= dict[storedProceduresLinkKey] 	as? String { self.storedProceduresLink = storedProceduresLink }
		if let triggersLink 			= dict[triggersLinkKey] 			as? String { self.triggersLink = triggersLink }
		if let userDefinedFunctionsLink = dict[userDefinedFunctionsLinkKey] as? String { self.userDefinedFunctionsLink = userDefinedFunctionsLink }
	}
	
	open override var dictionary: [String : Any] {
		return super.dictionary.merging([
			conflictsLinkKey:conflictsLink,
			documentsLinkKey:documentsLink,
			indexingPolicyKey:indexingPolicy?.dictionary ?? "",
			partitionKeyKey:partitionKey?.dictionary ?? "",
			storedProceduresLinkKey:storedProceduresLink,
			triggersLinkKey:triggersLink,
			userDefinedFunctionsLinkKey:userDefinedFunctionsLink])
		{ (_, new) in new }
	}
}
