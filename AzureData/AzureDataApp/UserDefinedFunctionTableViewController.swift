//
//  UserDefinedFunctionTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/24/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class UserDefinedFunctionTableViewController: UITableViewController {

    @IBOutlet var addButton: UIBarButtonItem!
    
    var database: ADDatabase!
    var collection: ADCollection!

    var resources: [ADUserDefinedFunction] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //refreshData()
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
    
    func refreshData() {
        AzureData.get(userDefinedFunctionsIn: collection.id, inDatabase: database.id) { r in
            debugPrint(r.result)
            if let items = r.resource?.items {
                self.resources = items
                self.reloadOnMainThread()
            } else if let error = r.error {
                self.showErrorAlert(error)
            }
            DispatchQueue.main.async {
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
    }

    func reloadOnMainThread() { DispatchQueue.main.async { self.tableView.reloadData() } }

    func showErrorAlert (_ error: ADError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true) { }
        }
    }

    
    @IBAction func addButtonTouchUpInside(_ sender: Any) { }
    
    
    @IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return resources.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)
        
        let resource = resources[indexPath.row]
        
        cell.textLabel?.text = resource.id
        cell.detailTextLabel?.text = resource.resourceId
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
            self.deleteResource(at: indexPath, from: tableView, callback: callback)
        }
        return UISwipeActionsConfiguration(actions: [ action ] );
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteResource(at: indexPath, from: tableView)
        }
    }
    
    
    func deleteResource(at indexPath: IndexPath, from tableView: UITableView, callback: ((Bool) -> Void)? = nil) {
        AzureData.delete(resources[indexPath.row], fromCollection: collection.id, inDatabase: database.id) { success in
            //collection.deleteDocument(self.documents[indexPath.row]) { success in
            if success {
                self.resources.remove(at: indexPath.row)
                DispatchQueue.main.async { tableView.deleteRows(at: [indexPath], with: .automatic) }
            }
            DispatchQueue.main.async { callback?(success) }
        }
    }
}
