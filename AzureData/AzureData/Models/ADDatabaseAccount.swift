//
//  ADDatabaseAccount.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADDatabaseAccount: ADResource {
	public var consistencyPolicy: 		String = ""
	public var databasesLink: 			String = ""
	public var maxMediaStorageUsageInMB:String = ""
	public var mediaLink: 				String = ""
	public var mediaStorageUsageInMB: 	String = ""
	public var readableLocations: 		String = ""
	public var writableLocation: 		String = ""
}
