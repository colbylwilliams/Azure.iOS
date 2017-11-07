//
//  CollectionTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class CollectionTableViewController: UITableViewController {

    let selectedSegmentIndexKey = "CollectionTableViewController.selectedSegmentIndex"
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var database: ADDatabase!
    
    var users: [ADUser] = []
    var collections: [ADCollection] = []
    
    var collectionsSelected: Bool {
        return segmentedControl.selectedSegmentIndex == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: selectedSegmentIndexKey)

        refreshData()
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

    
    func refreshData(fromUser: Bool = false) {
        if !fromUser || collectionsSelected {
            
            database.getCollections() { r in
                debugPrint(r.result)
                DispatchQueue.main.async {
                    if let items = r.resource?.items {
                        self.collections = items
                        self.tableView.reloadData()
                    } else if let error = r.error {
                        self.showErrorAlert(error)
                    }
                    if self.refreshControl?.isRefreshing ?? false {
                        self.refreshControl!.endRefreshing()
                    }
                }
            }
        }
        if !fromUser || !collectionsSelected {
            
            database.getUsers() { r in
                debugPrint(r.result)
                DispatchQueue.main.async {
                    if let items = r.resource?.items {
                        self.users = items
                        self.tableView.reloadData()
                    } else if let error = r.error {
                        self.showErrorAlert(error)
                    }
                    if self.refreshControl?.isRefreshing ?? false {
                        self.refreshControl!.endRefreshing()
                    }
                }
            }
        }
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: selectedSegmentIndexKey)
        tableView.reloadData()
    }
    
    
    @IBAction func refreshControlValueChanged(_ sender: Any) { refreshData(fromUser: true) }
    
    
    @IBAction func addButtonTouchUpInside(_ sender: Any) { showNewResourceAlert() }
    
    
    func showNewResourceAlert() {
        
        let resourceName = collectionsSelected ? "Collection" : "User"
        
        let alertController = UIAlertController(title: "New \(resourceName)", message: "Enter an ID for the new \(resourceName)", preferredStyle: .alert)
        
        alertController.addTextField() { textField in
            textField.placeholder = "\(resourceName) ID (no spaces)"
            textField.returnKeyType = .done
        }
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default) { a in
            
            if let name = alertController.textFields?.first?.text {
                if self.collectionsSelected {
                    
                    self.database.create(collectionWithId: name) { r in
                        debugPrint(r.result)
                        DispatchQueue.main.async {
                            if let collection = r.resource {
                                self.collections.append(collection)
                                self.tableView.reloadData()
                            } else if let error = r.error {
                                self.showErrorAlert(error)
                            }
                        }
                    }
                } else {
                    
                    self.database.create(userWithId: name) { r in
                        debugPrint(r.result)
                        DispatchQueue.main.async {
                            if let user = r.resource {
                                self.users.append(user)
                                self.tableView.reloadData()
                            } else if let error = r.error {
                                self.showErrorAlert(error)
                            }
                        }
                    }
                }
            }
        })
        
        present(alertController, animated: true) { }
    }

    
    func showErrorAlert (_ error: ADError) {
        let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        present(alertController, animated: true) { }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return collectionsSelected ? collections.count : users.count }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)

        let resource: ADResource = collectionsSelected ? collections[indexPath.row] : users[indexPath.row]
        
        cell.textLabel?.text = resource.id
        cell.detailTextLabel?.text = resource.resourceId

        return cell
    }

    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
            if self.collectionsSelected {
                
                self.database.get(collectionWithId: self.collections[indexPath.row].id) { r in
                    DispatchQueue.main.async {
                        if r.result.isSuccess {
                            debugPrint(r.result)
                            r.resource?.printLog()
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                            callback(false)
                        } else if let error = r.error {
                            self.showErrorAlert(error)
                            callback(false)
                        }
                    }
                }
            } else {
                
                self.database.get(userWithId: self.users[indexPath.row].id) { r in
                    DispatchQueue.main.async {
                        if r.result.isSuccess {
                            debugPrint(r.result)
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                            callback(false)
                        } else if let error = r.error {
                            self.showErrorAlert(error)
                            callback(false)
                        }
                    }
                }
            }
        }
        
        action.backgroundColor = UIColor.blue
        
        return UISwipeActionsConfiguration(actions: [ action ] );
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
        if collectionsSelected {

            database.delete(collections[indexPath.row]) { success in
                DispatchQueue.main.async {
                    if success {
                        self.collections.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    callback?(success)
                }
            }
        } else {
            
            database.delete(users[indexPath.row]) { success in
                DispatchQueue.main.async {
                    if success {
                        self.users.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    callback?(success)
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: collectionsSelected ? "collectionResourceSegue" : "permissionSegue", sender: tableView.cellForRow(at: indexPath))
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
            if segue.identifier == "collectionResourceSegue", let destinationViewController = segue.destination as? CollectionResourceTableViewController {
                destinationViewController.database = database
                destinationViewController.collection = collections[index.row]
            } else if segue.identifier == "permissionSegue", let destinationViewController = segue.destination as? PermissionTableViewController {
                destinationViewController.database = database
                destinationViewController.user = users[index.row]
                destinationViewController.collection = collections[0]
            }
        }
    }
}

