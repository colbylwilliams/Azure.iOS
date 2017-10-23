//
//  ADStoredProcedure.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADStoredProcedure: ADResource {

	let bodyKey = "body"

	public private(set) var body: String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)

		body = dict[bodyKey] as? String
	}
}
