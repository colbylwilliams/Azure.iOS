//
//  AppDelegate.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		AzureData.setup("mobile", key: "Np4cUd6IO3rFM6EMMoXBeGv4LKVrkfFDmws51nBpDFypym90IVPdjMQcy6SjmFMJklTwWglBhSAtoK07IwK7kg==", keyType: .master)
		
		//AzureData.setup("producerdocumentdb", key: "m8sKmtiotoEoZqRr65LcBCr6v2VxJyoKHbrWhjSTYlosgT2oc127VGGkEyA4n8Zjkdfb9ZoUpKoKjw1zktAcdw==", keyType: .master)
		
		// AzureData.setup("<Database Name>", key: "<Database Key>", keyType: .master)
		AzureData.printResponseJson(true)
		return true
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		showApiKeyAlert(application)
	}

	func showApiKeyAlert(_ application: UIApplication) {
		
		if !AzureData.isSetup() {
			
			let alertController = UIAlertController(title: "Configure App", message: "Enter a Azure Cosmos DB account name and read-write key. Or add the key in code in `didFinishLaunchingWithOptions`", preferredStyle: .alert)

			alertController.addTextField() { textField in
				textField.placeholder = "Database Name"
				textField.returnKeyType = .next
			}

			alertController.addTextField() { textField in
				textField.placeholder = "Read-write Key"
				textField.returnKeyType = .done
			}
			
			alertController.addAction(UIAlertAction(title: "Get Key", style: .default) { a in
				if let getKeyUrl = URL(string: "https://ms.portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.DocumentDb%2FdatabaseAccounts") {
					UIApplication.shared.open(getKeyUrl, options: [:]) { opened in
						print("Opened GetKey url successfully: \(opened)")
					}
				}
			})
			
			alertController.addAction(UIAlertAction(title: "Done", style: .default) { a in
				
				if let name = alertController.textFields?.first?.text, let key = alertController.textFields?.last?.text {
					print("name: \(name)")
					print("key: \(key)")

					AzureData.setup(name, key: key, keyType: .master)
				} else {
					self.showApiKeyAlert(application)
				}
			})
			
			window?.rootViewController?.present(alertController, animated: true) { }
		}
	}
}

