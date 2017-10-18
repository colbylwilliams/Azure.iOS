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
		
		AzureData.database("Content") { database in
			if let b = database {
				b.printPretty()
			} else {
				print("poop")
			}
		}

		AzureData.documentCollection("Content", collectionId: "Items") { collection in
//		AzureData.documentCollection("Content", collectionId: "AvContent") { collection in
			if let c = collection {
				c.printPretty()
			} else {
				print("poop")
			}
		}
		
		AzureData.document("Content", collectionId: "Items", documentId: "11f656df-15e6-4e5f-8b5b-d17e0d43243e") { document in
//		AzureData.document("Content", collectionId: "AvContent", documentId: "fec11285-6b4f-4691-84ef-752f672e07bc") { document in
			if let d = document {
				d.printPretty()
			} else {
				print("poop")
			}
		}
	}
}
