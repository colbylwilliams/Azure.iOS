//
//  ADResource.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

open class ADResource {
	
	let idKey = 						"id"
	let resourceIdKey = 				"_rid"
	let selfLinkKey = 					"_self"
	let etagKey = 						"_etag"
	let timestampKey = 					"_ts"
	
	open var id: 						String = ""
	public var resourceId: 				String = ""
	public var selfLink: 				String = ""
	public var etag: 					String = ""
	public var timestamp: 				Date?
	
	public init () { }
	
	required public init(fromJson dict: [String:Any]) {
		if let id 			= dict[idKey] 			as? String { self.id = id }
		if let resourceId 	= dict[resourceIdKey] 	as? String { self.resourceId = resourceId }
		if let selfLink 	= dict[selfLinkKey] 	as? String { self.selfLink = selfLink }
		if let etag 		= dict[etagKey] 		as? String { self.etag = etag }
		if let timestamp	= dict[timestampKey] 	as? Double { self.timestamp = Date(timeIntervalSince1970: timestamp) }
	}
	
	open var dictionary: [String:Any] {
		return [
			idKey		 :id,
			resourceIdKey:resourceId,
			selfLinkKey	 :selfLink,
			etagKey		 :etag,
			timestampKey :timestamp?.timeIntervalSince1970 ?? 0
		]
	}
	
	public func printLog() {
		print("")
		for i in dictionary {
			print(i)
		}
	}
}
