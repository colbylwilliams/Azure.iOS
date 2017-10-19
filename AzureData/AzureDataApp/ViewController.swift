//
//  ViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func buttonTouched(_ sender: Any) {
		
//		AzureData.database("Content") { v in v?.printLog() }

//		AzureData.documentCollection("Content", collectionId: "Items") { v in v?.printLog() }
//		AzureData.documentCollection("Content", collectionId: "AvContent") { v in v?.printLog() }

//		AzureData.document("Content", collectionId: "Items", documentId: "11f656df-15e6-4e5f-8b5b-d17e0d43243e") { v in v?.printLog() }
//		AzureData.document("Content", collectionId: "AvContent", documentId: "fec11285-6b4f-4691-84ef-752f672e07bc") { v in v?.printLog() }
		
//		let person = Person()
//		person.firstName = "Colby"
//		person.lastName = "Williams"
//		person.email = "colbyw@microsoft.com"
//		person.age = 29
//		AzureData.document("Content", collectionId: "Items", document: person) { v in v?.printLog() }
		
//		AzureData.documents("Content", collectionId: "Items", documentType: Person.self) { list in
//			if let items = list?.items {
//				for item in items {
//					item.printLog()
//				}
//			}
//		}
		
		AzureData.documentCollections("Content") { list in
			if let items = list?.items {
				for item in items {
					item.printLog()
				}
			}
		}
	}
}
