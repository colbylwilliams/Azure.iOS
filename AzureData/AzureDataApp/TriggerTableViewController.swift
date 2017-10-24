//
//  TriggerTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/24/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class TriggerTableViewController: UITableViewController {

	@IBOutlet var addButton: UIBarButtonItem!
	
	var database: ADDatabase?
	var documentCollection: ADDocumentCollection?

	var resources: [ADTrigger] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		//refreshData()
		
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

	
	func refreshData() {
		if let databaseId = database?.id, let documentCollectionId = documentCollection?.id {
			AzureData.triggers(databaseId, collectionId: documentCollectionId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.resources = items
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
			AzureData.delete(self.resources[indexPath.row], databaseId: self.database!.id, collectionId: self.documentCollection!.id) { success in
				if success {
					self.resources.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				callback(success)
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			AzureData.delete(self.resources[indexPath.row], databaseId: self.database!.id, collectionId: self.documentCollection!.id) { success in
				if success {
					self.resources.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
}
