//
//  ADDatabase.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADDatabase: ADResource {
	
	let collectionsLinkKey = "_colls"
	let usersLinkKey = 		 "_users"
	
	public private(set) var collectionsLink: String?
	public private(set) var usersLink: 		 String?
	
	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		collectionsLink = dict[collectionsLinkKey] 	as? String
		usersLink 		= dict[usersLinkKey] 		as? String
	}
	
	override public var dictionary: [String : Any] {
		return super.dictionary.merging([
			collectionsLinkKey:collectionsLink.valueOrEmpty,
			usersLinkKey:usersLink.valueOrEmpty])
		{ (_, new) in new }
	}
}
