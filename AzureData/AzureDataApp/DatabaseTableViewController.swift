//
//  DatabaseTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class DatabaseTableViewController: UITableViewController {

	
	var databases: [ADDatabase] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		refreshData()
    }
	
	func refreshData() {
		if AzureData.isSetup() {
			AzureData.databases { list in
				if let dbs = list?.items {
					self.databases = dbs
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
		
		let alertController = UIAlertController(title: "New Database", message: "Enter an ID for the Azure Cosmos DB database", preferredStyle: .alert)
		
		alertController.addTextField() { textField in
			textField.placeholder = "Database ID"
			textField.returnKeyType = .done
		}

		alertController.addAction(UIAlertAction(title: "Create", style: .default) { a in
			
			if let name = alertController.textFields?.first?.text {
				
				AzureData.createDatabase(name) { database in
					if let database = database {
						self.databases.append(database)
						self.tableView.reloadData()
					}
				}
			}
		})
		
		present(alertController, animated: true) { }
	}
	
	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return databases.count }

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "databaseCell", for: indexPath)
		
		let database = databases[indexPath.row]
		
		cell.textLabel?.text = database.id
		cell.detailTextLabel?.text = database.resourceId

        return cell
    }


	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			let item = self.databases[indexPath.row]
			AzureData.database(item.id) { database in
				database?.printLog()
				tableView.reloadRows(at: [indexPath], with: .automatic)
				callback(false)
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			let item = self.databases[indexPath.row]
			AzureData.delete(item) { success in
				if success {
					self.databases.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				callback(success)
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}

	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let item = self.databases[indexPath.row]
			AzureData.delete(item) { success in
				if success {
					self.databases.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
	
	
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? CollectionTableViewController {
			destinationViewController.databaseId = databases[index.row].id
		}
    }
}
