//
//  CollectionResourceTableViewController.swift
//  AzureData iOS Sample
//
//  Created by Colby Williams on 10/24/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class CollectionResourceTableViewController: UITableViewController {
    
    var database: ADDatabase!
    var collection: ADCollection!
    
    var documents:          [ADDocument] = []
    var storedProcedures:   [ADStoredProcedure] = []
    var triggers:           [ADTrigger] = []
    var udfs:               [ADUserDefinedFunction] = []
    
    func collectionResourceName(_ section: Int) -> String {
        switch section {
        case 0: return "Documents"
        case 1: return "Stored Procedures"
        case 2: return "Triggers"
        case 3: return "User Defined Functions"
        default: return ""
        }
    }
    
    func collectionResourceArray(_ section: Int) -> [ADResource] {
        switch section {
        case 0: return documents
        case 1: return storedProcedures
        case 2: return triggers
        case 3: return udfs
        default: return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
    }
    
    var refreshCount = 4
    
    func refreshData() {
        collection.get(documentsAs: ADDocument.self) { r in
            debugPrint(r.result)
            DispatchQueue.main.async {
                if let items = r.resource?.items {
                    self.documents = items
                    self.self.tableView.reloadData()
                } else if let error = r.error {
                    self.showErrorAlert(error)
                }
                self.finishedRefresh()
            }
        }
        
        collection.getStoredProcedures() { r in
            debugPrint(r.result)
            DispatchQueue.main.async {
                if let items = r.resource?.items {
                    self.storedProcedures = items
                    self.self.tableView.reloadData()
                } else if let error = r.error {
                    self.showErrorAlert(error)
                }
                self.finishedRefresh()
            }
        }
        
        collection.getTriggers() { r in
            debugPrint(r.result)
            DispatchQueue.main.async {
                if let items = r.resource?.items {
                    self.triggers = items
                    self.self.tableView.reloadData()
                } else if let error = r.error {
                    self.showErrorAlert(error)
                }
                self.finishedRefresh()
            }
        }
        
        collection.getUserDefinedFunctions() { r in
            debugPrint(r.result)
            DispatchQueue.main.async {
                if let items = r.resource?.items {
                    self.udfs = items
                    self.self.tableView.reloadData()
                } else if let error = r.error {
                    self.showErrorAlert(error)
                }
                self.finishedRefresh()
            }
        }
    }
    
    
    func finishedRefresh() {
        if refreshControl?.isRefreshing ?? false {
            refreshCount -= 1
            if refreshCount <= 0 {
                refreshControl!.endRefreshing()
                refreshCount = 4
            }
        }
        print("refreshCount = \(refreshCount)")
    }
    

    func showErrorAlert (_ error: ADError) {
        let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        present(alertController, animated: true) { }
    }

    
    @IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 4 }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)

        cell.textLabel?.text = collectionResourceName(indexPath.row)
        cell.detailTextLabel?.text = "\(collectionResourceArray(indexPath.row).count)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: performSegue(withIdentifier: collectionSegue.document.rawValue, sender: tableView.cellForRow(at: indexPath))
        case 1: performSegue(withIdentifier: collectionSegue.storedProcedure.rawValue, sender: tableView.cellForRow(at: indexPath))
        case 2: performSegue(withIdentifier: collectionSegue.trigger.rawValue, sender: tableView.cellForRow(at: indexPath))
        case 3: performSegue(withIdentifier: collectionSegue.userDefinedFunction.rawValue, sender: tableView.cellForRow(at: indexPath))
        default: return
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case collectionSegue.document.rawValue:
                if let destinationViewController = segue.destination as? DocumentTableViewController {
                    destinationViewController.database = database
                    destinationViewController.collection = collection
                }
            case collectionSegue.storedProcedure.rawValue:
                if let destinationViewController = segue.destination as? StoredProcedureTableViewController {
                    destinationViewController.database = database
                    destinationViewController.collection = collection
                    destinationViewController.resources = storedProcedures
                }
            case collectionSegue.trigger.rawValue:
                if let destinationViewController = segue.destination as? TriggerTableViewController {
                    destinationViewController.database = database
                    destinationViewController.collection = collection
                    destinationViewController.resources = triggers
                }
            case collectionSegue.userDefinedFunction.rawValue:
                if let destinationViewController = segue.destination as? UserDefinedFunctionTableViewController {
                    destinationViewController.database = database
                    destinationViewController.collection = collection
                    destinationViewController.resources = udfs
                }
            default: return
            }
        }
    }
}

enum collectionSegue: String {
    case document = "documentsSegue"
    case permission = "permissionSegue"
    case storedProcedure = "storedProcedureSegue"
    case trigger = "triggerSegue"
    case userDefinedFunction = "userDefinedFunctionSegue"
}
