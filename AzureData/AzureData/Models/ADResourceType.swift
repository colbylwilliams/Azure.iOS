//
//  ADResourceType.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public enum ADResourceType : String {
	case database				= "dbs"
	case user					= "users"
	case permission				= "permissions"
	case collection				= "colls"
	case storedProcedure		= "sprocs"
	case trigger				= "triggers"
	case udf					= "udfs"
	case document				= "docs"
	case attachment				= "attachments"
	case offer					= "offers"
	
	var path: String {
		switch self {
		case .database: 		return "dbs"
		case .user: 			return "users"
		case .permission: 		return "permissions"
		case .collection: 		return "colls"
		case .storedProcedure: 	return "sprocs"
		case .trigger: 			return "triggers"
		case .udf: 				return "udfs"
		case .document: 		return "docs"
		case .attachment: 		return "attachments"
		case .offer: 			return "offers"
		}
	}
}
