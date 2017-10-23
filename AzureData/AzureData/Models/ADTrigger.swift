//
//  ADTrigger.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADTrigger: ADResource {

	let bodyKey 				= "body"
	let triggerOpertationKey 	= "triggerOpertation"
	let triggerTypeKey 			= "triggerType"

	public private(set) var body: 				String?
	public private(set) var triggerOpertation:	String?
	public private(set) var triggerType: 		String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)

		body = dict[bodyKey] as? String
		triggerOpertation = dict[triggerOpertationKey] as? String
		triggerType = dict[triggerTypeKey] as? String
	}
}
