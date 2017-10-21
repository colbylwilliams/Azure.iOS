//
//  ADDatabaseAccount.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADDatabaseAccount: ADResource {
	public private(set) var consistencyPolicy: 			String?
	public private(set) var databasesLink: 				String?
	public private(set) var maxMediaStorageUsageInMB:	String?
	public private(set) var mediaLink: 				 	String?
	public private(set) var mediaStorageUsageInMB: 		String?
	public private(set) var readableLocations: 			String?
	public private(set) var writableLocation: 			String?
}
