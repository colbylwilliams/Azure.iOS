//
//  ADAttachment.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADAttachment: ADResource {
	
	let contentTypeKey 	= "contentType"
	let mediaLinkKey 	= "mediaLink"

	public private(set) var contentType:String?
	public private(set) var mediaLink: 	String?

	required public init?(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		contentType = dict[contentTypeKey] as? String
		mediaLink = dict[mediaLinkKey] as? String
	}
}
