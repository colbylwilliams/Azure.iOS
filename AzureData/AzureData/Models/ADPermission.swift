//
//  ADPermission.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADPermission: ADResource {
	public private(set) var permissionMode: 		String?
	public private(set) var resourceLink: 			String?
	public private(set) var resourcePartitionKey:	String?
	public private(set) var token: 					String?
}
