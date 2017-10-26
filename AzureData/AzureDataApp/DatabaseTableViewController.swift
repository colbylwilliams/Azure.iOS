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

	let selectedSegmentIndexKey = "DatabaseTableViewController.selectedSegmentIndex"
	
	@IBOutlet weak var addButton: UIBarButtonItem!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var offers: [ADOffer] = []
	var databases: [ADDatabase] = []
	
	var databasesSelected: Bool {
		return segmentedControl.selectedSegmentIndex == 0
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: selectedSegmentIndexKey)
		
		addButton.isEnabled = databasesSelected
		
		refreshData()
    }
	
	
	func refreshData(fromUser: Bool = false) {
        if !fromUser || databasesSelected {
            AzureData.databases { r in
                debugPrint(r.result)
                if let databases = r.resource?.items {
                    self.databases = databases
                    if self.databasesSelected {
                        self.tableView.reloadData()
                    }
                } else if let error = r.result.error {
                    self.showErrorAlert(error)
                }
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
        if fromUser || !databasesSelected {
            AzureData.offers { r in
                debugPrint(r.result)
                if let offers = r.resource?.items {
                    self.offers = offers
                    if !self.databasesSelected {
                        self.tableView.reloadData()
                    }
                } else if let error = r.result.error {
                    self.showErrorAlert(error)
                }
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
	}

	
	@IBAction func segmentedControlValueChanged(_ sender: Any) {
		UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: selectedSegmentIndexKey)
		addButton.isEnabled = databasesSelected
		tableView.reloadData()
	}
	
	
	@IBAction func refreshControlValueChanged(_ sender: Any) { refreshData(fromUser: true) }
	
	
	@IBAction func addButtonTouchUpInside(_ sender: Any) { showNewResourceAlert() }
	
	
	func showNewResourceAlert() {
		
		let alertController = UIAlertController(title: "New Database", message: "Enter an ID for the new Database", preferredStyle: .alert)
		
		alertController.addTextField() { textField in
			textField.placeholder = "Database ID"
			textField.returnKeyType = .done
		}

		alertController.addAction(UIAlertAction(title: "Create", style: .default) { a in
			
			if let name = alertController.textFields?.first?.text {
				AzureData.create(databaseWithId: name) { r in
					if let database = r.resource {
						self.databases.append(database)
						self.tableView.reloadData()
					} else if let error = r.error {
						self.showErrorAlert(error)
					}
				}
			}
		})
		present(alertController, animated: true) { }
	}
	
	var presentingAlert = false
	
	func showErrorAlert (_ error: ADError) {
		if !presentingAlert {
		
			presentingAlert = true
			let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
			alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel) { a in self.presentingAlert = false })
			present(alertController, animated: true) { }
		}
	}

	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return databasesSelected ? databases.count : offers.count }

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)
		
		let resource: ADResource = databasesSelected ? databases[indexPath.row] : offers[indexPath.row]
		
		cell.textLabel?.text = resource.id
		cell.detailTextLabel?.text = resource.resourceId

        return cell
    }


	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			if self.databasesSelected {
				AzureData.get(databaseWithId: self.databases[indexPath.row].id) { r in
					debugPrint(r.result)
					r.resource?.printLog()
					tableView.reloadRows(at: [indexPath], with: .automatic)
					callback(false)
				}
			} else {
				AzureData.get(offerWithId: self.offers[indexPath.row].id) { r in
					debugPrint(r.result)
					tableView.reloadRows(at: [indexPath], with: .automatic)
					callback(false)
				}
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if !databasesSelected { return UISwipeActionsConfiguration.init(actions: [])}
		
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			AzureData.delete(self.databases[indexPath.row]) { success in
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
		if editingStyle == .delete && databasesSelected {
			AzureData.delete(self.databases[indexPath.row]) { success in
				if success {
					self.databases.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return databasesSelected ? indexPath : nil
	}
	
	
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? CollectionTableViewController {
			destinationViewController.database = databases[index.row]
		}
    }
}
