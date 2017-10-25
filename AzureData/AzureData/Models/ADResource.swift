//
//  ADResource.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

open class ADResource {
	
	static let idKey = 			"id"
	static let resourceIdKey = 	"_rid"
	static let selfLinkKey = 	"_self"
	static let etagKey = 		"_etag"
	static let timestampKey = 	"_ts"
	
	open private(set) 	var id:         String
	public private(set) var resourceId:	String
	public private(set) var selfLink: 	String?
	public private(set) var etag: 		String?
	public private(set) var timestamp: 	Date?
	
    public init () { id = UUID().uuidString; resourceId = "" }
	
	public init (_ id: String) { self.id = id; resourceId = "" }
	
	required public init?(fromJson dict: [String:Any]) {
		if let id = dict[ADResource.idKey] as? String { self.id = id } else { return nil }
        if let resourceId = dict[ADResource.resourceIdKey] as? String { self.resourceId = resourceId } else { return nil }
		selfLink 	= dict[ADResource.selfLinkKey] 		as? String
		etag 		= dict[ADResource.etagKey] 			as? String
		if let time	= dict[ADResource.timestampKey] 	as? Double {
			self.timestamp = Date(timeIntervalSince1970: time)
		}
	}
	
	open var dictionary: [String:Any] {
		return [
			ADResource.idKey		:id,
			ADResource.resourceIdKey:resourceId,
			ADResource.selfLinkKey	:selfLink.valueOrEmpty,
			ADResource.etagKey		:etag.valueOrEmpty,
			ADResource.timestampKey	:timestamp?.timeIntervalSince1970 ?? 0
		]
	}
	
	public func printLog() {
		print("")
		for i in dictionary {
			print(i)
		}
	}
}
