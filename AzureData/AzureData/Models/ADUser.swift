//
//  ADUser.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADUser: ADResource {

	let permissionsLinkKey = "permissionsLink"

	public private(set) var permissionsLink: String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)

		permissionsLink = dict[permissionsLinkKey] as? String
	}
}
