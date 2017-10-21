//
//  ADConflict.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADConflict: ADResource {
	public private(set) var operationKind: 	 String?
	public private(set) var resourceType: 	 String?
	public private(set) var sourceResourceId:String?
}
