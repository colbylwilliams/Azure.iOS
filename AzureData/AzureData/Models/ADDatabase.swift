//
//  ADDatabase.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADDatabase: ADResource {
	
	let collectionsLinkKey = 			"_colls"
	let usersLinkKey = 					"_users"
	
	public var collectionsLink: 		String = ""
	public var usersLink: 				String = ""
	
	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		if let collectionsLink  = dict[collectionsLinkKey] 	as? String { self.collectionsLink = collectionsLink }
		if let usersLink 		= dict[usersLinkKey] 		as? String { self.usersLink = usersLink }
	}
}
