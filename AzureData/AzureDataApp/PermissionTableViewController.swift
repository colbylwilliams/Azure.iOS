//
//  PermissionTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/23/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class PermissionTableViewController: UITableViewController {

	@IBOutlet weak var addButton: UIBarButtonItem!
	
	var user: ADUser?
	var documentCollection: ADDocumentCollection?
	var database: ADDatabase?
	
	var permissions: [ADPermission] = []
	
    override func viewDidLoad() {
		super.viewDidLoad()
		refreshData()
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
	
	
	func refreshData() {
		if let databaseId = database?.id, let userId = user?.id {
			AzureData.permissions(databaseId, userId: userId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					self.permissions = items
					self.tableView.reloadData()
				} else if let error = response.error {
					self.showErrorAlert(error)
				}
				if self.refreshControl?.isRefreshing ?? false {
					self.refreshControl!.endRefreshing()
				}
			}
		}
	}
	
	
	func showErrorAlert (_ error: ADError) {
		let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
		present(alertController, animated: true) { }
	}

	
	@IBAction func addButtonTouchUpInside(_ sender: Any) {
		
		let alertController = UIAlertController(title: "New Database Permission", message: "Enter the following information for the new Permission", preferredStyle: .alert)
		
		alertController.addTextField() { textField in
			textField.placeholder = "Permission ID (no spaces)"
			textField.returnKeyType = .next
		}
		
		alertController.addTextField() { textField in
			textField.text = "Read"
			textField.placeholder = "Read or All"
			textField.returnKeyType = .done
		}
		
		alertController.addAction(UIAlertAction(title: "Create", style: .default) { a in
			
			if let id = alertController.textFields?.first?.text, let mode = alertController.textFields?.last?.text {
				debugPrint("id: \(id)")
				debugPrint("mode: \(mode)")
				
				AzureData.createPermission(self.documentCollection!, databaseId: self.database!.id, userId: self.user!.id, permissionId: id, permissionMode: .read) { response in
					debugPrint(response.result)
					if let permission = response.resource {
						self.permissions.append(permission)
						self.tableView.reloadData()
					} else if let error = response.error {
						self.showErrorAlert(error)
					}
				}
			}
		})
		
		present(alertController, animated: true) { }
	}
	

	@IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
	
	
	// MARK: - Table view data source
	
	
	override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return permissions.count }


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "permissionCell", for: indexPath)
		
		let permission = permissions[indexPath.row]
		
		cell.textLabel?.text = permission.id
		cell.detailTextLabel?.text = permission.resourceId
		
		return cell
    }

	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			AzureData.permission(self.database!.id, userId: self.user!.id, permissionId: self.permissions[indexPath.row].id) { response in
				debugPrint(response.result)
				tableView.reloadRows(at: [indexPath], with: .automatic)
				callback(false)
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			AzureData.delete(self.permissions[indexPath.row], databaseId: self.database!.id, userId: self.user!.id) { success in
				if success {
					self.permissions.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				callback(success)
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			AzureData.delete(self.permissions[indexPath.row], databaseId: self.database!.id, userId: self.user!.id) { success in
				if success {
					self.permissions.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
}
