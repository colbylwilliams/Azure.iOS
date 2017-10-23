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

	@IBOutlet var addButton: UIBarButtonItem!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var databaseId: String?
	
	var users: [ADUser] = []
	var documentCollections: [ADDocumentCollection] = []
	
	var collectionsSelected: Bool {
		return segmentedControl.selectedSegmentIndex == 0
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		refreshData()
		
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

	
	func refreshData(fromUser: Bool = false) {
		if let database = databaseId {
			if !fromUser || collectionsSelected {
				AzureData.documentCollections(database) { response in
					debugPrint(response.result)
					if let items = response.resource?.items {
						self.documentCollections = items
						self.tableView.reloadData()
					} else {
						response.error?.printLog()
					}
					if self.refreshControl?.isRefreshing ?? false {
						self.refreshControl!.endRefreshing()
					}
				}
			}
			if !fromUser || !collectionsSelected {
				AzureData.users(database) { response in
					debugPrint(response.result)
					if let items = response.resource?.items {
						self.users = items
						self.tableView.reloadData()
					} else {
						response.error?.printLog()
					}
					if self.refreshControl?.isRefreshing ?? false {
						self.refreshControl!.endRefreshing()
					}
				}
			}
		}
	}
	
	
	@IBAction func segmentedControlValueChanged(_ sender: Any) { tableView.reloadData()	}
	
	
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
					AzureData.createDocumentCollection(self.databaseId!, collectionId: name) { response in
						debugPrint(response.result)
						if let collection = response.resource {
							self.documentCollections.append(collection)
							self.tableView.reloadData()
						} else { response.error?.printLog() }
					}
				} else {
					AzureData.createUser(self.databaseId!, userId: name) { response in
						debugPrint(response.result)
						if let user = response.resource {
							self.users.append(user)
							self.tableView.reloadData()
						} else { response.error?.printLog() }
					}
				}
			}
		})
		
		present(alertController, animated: true) { }
	}

	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return collectionsSelected ? documentCollections.count : users.count }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)

		let resource: ADResource = collectionsSelected ? documentCollections[indexPath.row] : users[indexPath.row]
		
		cell.textLabel?.text = resource.id
		cell.detailTextLabel?.text = resource.resourceId

        return cell
    }

	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			if self.collectionsSelected {
				AzureData.documentCollection(self.databaseId!, collectionId: self.documentCollections[indexPath.row].id) { response in
					debugPrint(response.result)
					response.resource?.printLog()
					tableView.reloadRows(at: [indexPath], with: .automatic)
					callback(false)
				}
			} else {
				AzureData.user(self.databaseId!, userId: self.users[indexPath.row].id) { response in
					debugPrint(response.result)
					tableView.reloadRows(at: [indexPath], with: .automatic)
					callback(false)
				}
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			if self.collectionsSelected {
				AzureData.delete(self.documentCollections[indexPath.row], databaseId: self.databaseId!) { success in
					if success {
						self.documentCollections.remove(at: indexPath.row)
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
					callback(success)
				}
			} else {
				AzureData.delete(self.users[indexPath.row], databaseId: self.databaseId!) { success in
					if success {
						self.users.remove(at: indexPath.row)
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
					callback(success)
				}
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}

	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if self.collectionsSelected {
				AzureData.delete(self.documentCollections[indexPath.row], databaseId: self.databaseId!) { success in
					if success {
						self.documentCollections.remove(at: indexPath.row)
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			} else {
				AzureData.delete(self.users[indexPath.row], databaseId: self.databaseId!) { success in
					if success {
						self.users.remove(at: indexPath.row)
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: collectionsSelected ? "documentsSegue" : "permissionSegue", sender: tableView.cellForRow(at: indexPath))
	}
	

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
			if segue.identifier == "documentsSegue", let destinationViewController = segue.destination as? DocumentTableViewController {
				destinationViewController.databaseId = databaseId
				destinationViewController.documentCollectionId = documentCollections[index.row].id
			} else if segue.identifier == "permissionSegue", let destinationViewController = segue.destination as? PermissionTableViewController {
				destinationViewController.databaseId = databaseId
				destinationViewController.userId = users[index.row].id
			}
		}
    }
}
