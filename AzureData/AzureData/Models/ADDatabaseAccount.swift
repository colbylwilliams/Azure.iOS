//
//  ADDatabaseAccount.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADDatabaseAccount: ADResource {

	let consistencyPolicyKey 		= "consistencyPolicy"
	let databasesLinkKey 			= "databasesLink"
	let maxMediaStorageUsageInMBKey = "maxMediaStorageUsageInMB"
	let mediaLinkKey 				= "mediaLink"
	let mediaStorageUsageInMBKey 	= "mediaStorageUsageInMB"
	let readableLocationsKey 		= "readableLocations"
	let writableLocationKey 		= "writableLocation"

	public private(set) var consistencyPolicy: 			String?
	public private(set) var databasesLink: 				String?
	public private(set) var maxMediaStorageUsageInMB:	String?
	public private(set) var mediaLink: 				 	String?
	public private(set) var mediaStorageUsageInMB: 		String?
	public private(set) var readableLocations: 			String?
	public private(set) var writableLocation: 			String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		consistencyPolicy = dict[consistencyPolicyKey] as? String
		databasesLink = dict[databasesLinkKey] as? String
		maxMediaStorageUsageInMB = dict[maxMediaStorageUsageInMBKey] as? String
		mediaLink = dict[mediaLinkKey] as? String
		mediaStorageUsageInMB = dict[mediaStorageUsageInMBKey] as? String
		readableLocations = dict[readableLocationsKey] as? String
		writableLocation = dict[writableLocationKey] as? String
	}
}
