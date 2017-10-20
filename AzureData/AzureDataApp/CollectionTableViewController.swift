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
	
	var databaseId: String?
	
	var documentCollections: [ADDocumentCollection] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		refreshData()
		
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

	func refreshData() {
		if let database = databaseId {
			AzureData.documentCollections(database) { list in
				if let items = list?.items {
					self.documentCollections = items
					self.tableView.reloadData()
				}
				if self.refreshControl?.isRefreshing ?? false {
					self.refreshControl!.endRefreshing()
				}
			}
		}
	}
	
	
	@IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
	
	
	@IBAction func addButtonTouchUpInside(_ sender: Any) { showNewResourceAlert() }
	
	
	func showNewResourceAlert() {
		
		let alertController = UIAlertController(title: "New Collection", message: "Enter an ID for the Azure Cosmos DB collection", preferredStyle: .alert)
		
		alertController.addTextField() { textField in
			textField.placeholder = "Collection ID (no spaces)"
			textField.returnKeyType = .done
		}
		
		alertController.addAction(UIAlertAction(title: "Create", style: .default) { a in
			
			if let name = alertController.textFields?.first?.text {
				
				AzureData.createDocumentCollection(self.databaseId!, collectionId: name) { collection in
					if let collection = collection {
						self.documentCollections.append(collection)
						self.tableView.reloadData()
					}
				}
			}
		})
		
		present(alertController, animated: true) { }
	}

	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return documentCollections.count }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)

		let documentCollection = documentCollections[indexPath.row]
		
        cell.textLabel?.text = documentCollection.id
		cell.detailTextLabel?.text = documentCollection.resourceId
		
        return cell
    }

	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			let item = self.documentCollections[indexPath.row]
			AzureData.documentCollection(self.databaseId!, collectionId: item.id) { collection in
				collection?.printLog()
				tableView.reloadRows(at: [indexPath], with: .automatic)
				callback(false)
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			let item = self.documentCollections[indexPath.row]
			AzureData.delete(item, databaseId: self.databaseId!) { success in
				if success {
					self.documentCollections.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				callback(success)
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}

	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let item = self.documentCollections[indexPath.row]
			AzureData.delete(item, databaseId: self.databaseId!) { success in
				if success {
					self.documentCollections.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
	

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? DocumentTableViewController {
			destinationViewController.databaseId = databaseId
			destinationViewController.documentCollectionId = documentCollections[index.row].id
		}
    }
}
