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
	
	var userId: String?
	var databaseId: String?
	
	var permissions: [ADPermission] = []
	
    override func viewDidLoad() {
		super.viewDidLoad()
		refreshData()
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
	
	
	func refreshData() {
		if let database = databaseId, let user = userId {
			AzureData.permissions(database, userId: user) { response in
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
			AzureData.permission(self.databaseId!, userId: self.userId!, permissionId: self.permissions[indexPath.row].id) { response in
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
			AzureData.delete(self.permissions[indexPath.row], databaseId: self.databaseId!, userId: self.userId!) { success in
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
			AzureData.delete(self.permissions[indexPath.row], databaseId: self.databaseId!, userId: self.userId!) { success in
				if success {
					self.permissions.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
}
