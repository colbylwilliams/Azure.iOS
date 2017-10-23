//
//  ADOffer.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADOffer: ADResource {

	let offerTypeKey 	= "offerType"
	let offerVersionKey = "offerVersion"
	let resourceLinkKey = "resourceLink"
	let contentKey 		= "content"

	public private(set) var offerType: 		String?
	public private(set) var offerVersion:	String?
	public private(set) var resourceLink:	String?
	public private(set) var content:		ADOfferContent?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		offerType = dict[offerTypeKey] as? String
		offerVersion = dict[offerVersionKey] as? String
		resourceLink = dict[resourceLinkKey] as? String
		if let content = dict[contentKey] as? [String:Any] { self.content = ADOfferContent(fromJson: content) }
	}
}


public class ADOfferContent {
	
	let offerThroughputKey = "offerThroughput"
	let offerIsRUPerMinuteThroughputEnabledKey = "offerIsRUPerMinuteThroughputEnabled"
	
	public private(set) var offerThroughput: Int = 1000
	public private(set) var offerIsRUPerMinuteThroughputEnabled: Bool?
	
	required public init(fromJson dict: [String:Any]) {
		if let offerThroughput = dict[offerThroughputKey] as? Int, offerThroughput >= 400 { self.offerThroughput = offerThroughput }
		offerIsRUPerMinuteThroughputEnabled = dict[offerIsRUPerMinuteThroughputEnabledKey] as? Bool
	}
}
