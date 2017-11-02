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
        
        // AzureData.setup("<Database Name>", key: "<Database Key>", keyType: .master, verboseLogging: true)
        
        if let accountName = Bundle.main.infoDictionary?["ADDatabaseAccountName"] as? String,
            let accountKey  = Bundle.main.infoDictionary?["ADDatabaseAccountKey"] as? String {
            AzureData.setup(accountName, key: accountKey, verboseLogging: true)
        }

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

