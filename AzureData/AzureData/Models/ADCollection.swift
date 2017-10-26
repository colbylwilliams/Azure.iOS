//
//  ADCollection.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADCollection: ADResource {
	
	let conflictsLinkKey 				= "_conflicts"
	let documentsLinkKey 				= "_docs"
	let indexingPolicyKey 				= "indexingPolicy"
	let partitionKeyKey					= "partitionKey"
	let storedProceduresLinkKey 		= "_sprocs"
	let triggersLinkKey 				= "_triggers"
	let userDefinedFunctionsLinkKey 	= "_udfs"
	
	public private(set) var conflictsLink: 			 String?
	public private(set) var documentsLink: 			 String?
	public private(set) var indexingPolicy: 		 ADIndexingPolicy?
	public private(set) var partitionKey: 			 ADPartitionKeyDefinition?
	public private(set) var storedProceduresLink: 	 String?
	public private(set) var triggersLink: 			 String?
	public private(set) var userDefinedFunctionsLink:String?
	
    public override init(_ id: String) { super.init(id) }
    
	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		conflictsLink 				= dict[conflictsLinkKey] 			as? String
		documentsLink 				= dict[documentsLinkKey] 			as? String
		if let indexingPolicy		= dict[indexingPolicyKey] 			as? [String:Any] { self.indexingPolicy = ADIndexingPolicy(fromJson: indexingPolicy) }
		if let partitionKey 		= dict[partitionKeyKey] 			as? [String:Any] { self.partitionKey = ADPartitionKeyDefinition(fromJson: partitionKey) }
		storedProceduresLink 		= dict[storedProceduresLinkKey] 	as? String
		triggersLink 				= dict[triggersLinkKey] 			as? String
		userDefinedFunctionsLink	= dict[userDefinedFunctionsLinkKey] as? String
	}
    
	open override var dictionary: [String : Any] {
		return super.dictionary.merging([
			conflictsLinkKey:conflictsLink.valueOrEmpty,
			documentsLinkKey:documentsLink.valueOrEmpty,
			indexingPolicyKey:indexingPolicy?.dictionary ?? "",
			partitionKeyKey:partitionKey?.dictionary	 ?? "",
			storedProceduresLinkKey:storedProceduresLink.valueOrEmpty,
			triggersLinkKey:triggersLink.valueOrEmpty,
			userDefinedFunctionsLinkKey:userDefinedFunctionsLink.valueOrEmpty])
		{ (_, new) in new }
	}
}