//
//  ADDocument.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

open class ADDocument: ADResource {
	
	let attachmentsLinkKey 				= "_attachments"
	
	public var attachmentsLink: 		String = ""
	
	override public init () {
		super.init()
		id = UUID().uuidString
	}
	
	required public init(fromJson dict: [String:Any]) {
		super.init(fromJson: dict)
		
		if let attachmentsLink 	= dict[attachmentsLinkKey] 	as? String { self.attachmentsLink = attachmentsLink }
	}
	
	open override var dictionary: [String : Any] {
		return super.dictionary.merging([
			attachmentsLinkKey:attachmentsLink])
		{ (_, new) in new }
	}
}
