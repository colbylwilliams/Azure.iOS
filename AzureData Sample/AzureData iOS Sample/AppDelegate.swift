//
//  AppDelegate.swift
//  AzureData iOS Sample
//
//  Created by Colby Williams on 11/8/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let databaseAccountNameKey     = "ADDatabaseAccountName"
    let databaseAccountKeyKey      = "ADDatabaseAccountKey"


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        let accountName = UserDefaults.standard.string(forKey: databaseAccountNameKey)  ?? Bundle.main.infoDictionary?[databaseAccountNameKey]  as? String
        let accountKey  = UserDefaults.standard.string(forKey: databaseAccountKeyKey)   ?? Bundle.main.infoDictionary?[databaseAccountKeyKey]   as? String
            
        storeDatabaseAccount(name: accountName, key: accountKey, andCallSetup: true)
    }
    

    func storeDatabaseAccount(name: String?, key: String?, andCallSetup callSetup: Bool = false) {
        
        print("storeDatabaseAccount name: \(name ?? "nil") key: \(key ?? "nil")")
        
        UserDefaults.standard.set(name, forKey: databaseAccountNameKey)
        UserDefaults.standard.set(key, forKey: databaseAccountKeyKey)

        if let n = name, let k = key {
            if callSetup { AzureData.setup(n, key: k) }
        } else {
            AzureData.reset()
        }
        
        showApiKeyAlert(UIApplication.shared)
    }
    
    
    func showApiKeyAlert(_ application: UIApplication) {
        
        if AzureData.isSetup() {
            
            if let navController = window?.rootViewController as? UINavigationController, let databaseController = navController.topViewController as? DatabaseTableViewController {
                databaseController.refreshData()
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Configure App", message: "Enter a Azure Cosmos DB account name and read-write key. Or add the key in code in `applicationDidBecomeActive`", preferredStyle: .alert)
            
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
                
                self.storeDatabaseAccount(name: alertController.textFields?.first?.text, key: alertController.textFields?.last?.text, andCallSetup: true)
            })
            
            window?.rootViewController?.present(alertController, animated: true) { }
        }
    }
}

