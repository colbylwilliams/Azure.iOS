//
//  ADPartitionKeyRange.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADPartitionKeyRange: ADResource {
	
	let parentsKey = "parents"

	public private(set) var parents: String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)

		parents = dict[parentsKey] as? String
	}
}
