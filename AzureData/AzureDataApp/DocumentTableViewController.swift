//
//  DocumentTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit
import AzureData

class DocumentTableViewController: UITableViewController {

	@IBOutlet var addButton: UIBarButtonItem!
	
	var database: ADDatabase?
	var documentCollection: ADDocumentCollection?
	
	//var documents:[Person] = []
	//var documents:[CustomDocument] = []
	var documents: 			[ADDocument] = []
	var storedProcedures: 	[ADStoredProcedure] = []
	var triggers: 			[ADTrigger] = []
	var udfs: 				[ADUserDefinedFunction] = []

	func resourceCollectionTitle(_ section: Int) -> String {
		switch section {
		case 0: return "Documents"
		case 1: return "Stored Procedures"
		case 2: return "Triggers"
		case 3: return "User Defined Functions"
		default: return ""
		}
	}
	func resourceCollection(_ section: Int) -> [ADResource] {
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
		
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

	
	func refreshData() {
		if let databaseId = database?.id, let documentCollectionId = documentCollection?.id {
			//AzureData.documents(Person.self, databaseId: database, collectionId: documentCollection) { list in
			//AzureData.documents(CustomDocument.self, databaseId: database, collectionId: documentCollection) { list in
			AzureData.documents(ADDocument.self, databaseId: databaseId, collectionId: documentCollectionId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.documents = items
					self.tableView.reloadData()
				} else if let error = response.error {
					self.showErrorAlert(error)
				}
				if self.refreshControl?.isRefreshing ?? false {
					self.refreshControl!.endRefreshing()
				}
			}
			AzureData.storedProcedures(databaseId, collectionId: documentCollectionId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.storedProcedures = items
					self.tableView.reloadData()
				} else if let error = response.error {
					self.showErrorAlert(error)
				}
				if self.refreshControl?.isRefreshing ?? false {
					self.refreshControl!.endRefreshing()
				}
			}
			AzureData.triggers(databaseId, collectionId: documentCollectionId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.triggers = items
					self.tableView.reloadData()
				} else if let error = response.error {
					self.showErrorAlert(error)
				}
				if self.refreshControl?.isRefreshing ?? false {
					self.refreshControl!.endRefreshing()
				}
			}
			AzureData.userDefinedFunctions(databaseId, collectionId: documentCollectionId) { response in
				debugPrint(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.udfs = items
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

	
	@IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
	
	
	@IBAction func addButtonTouchUpInside(_ sender: Any) {
		if let databaseId = database?.id, let documentCollectionId = documentCollection?.id {
			
			let doc = ADDocument()
			
			doc["testNumber"] = 1_500_000
			doc["testString"] = "Yeah baby\nRock n Roll"
//			doc["id"] = "foo"
			doc["testDate"]   = Date().timeIntervalSince1970
			
			AzureData.createDocument(databaseId, collectionId: documentCollectionId, document: doc) { response in
				debugPrint(response.result)
				if let document = response.resource {
					self.documents.append(document)
					self.tableView.reloadData()
				} else if let error = response.error {
					self.showErrorAlert(error)
				}
			}
		}
	}
	
	
	func showErrorAlert (_ error: ADError) {
		let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
		present(alertController, animated: true) { }
	}

	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 4 }

	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return resourceCollection(section).count }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)

		let resource = resourceCollection(indexPath.section)[indexPath.row]
		
		cell.textLabel?.text = resource.id
		cell.detailTextLabel?.text = resource.resourceId
		
        return cell
    }

	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			AzureData.document(CustomDocument.self, databaseId: self.database!.id, collectionId: self.documentCollection!.id, documentId: self.documents[indexPath.row].id) { response in
				if response.result.isSuccess {
					debugPrint(response.result)
					response.resource?.printLog()
					tableView.reloadRows(at: [indexPath], with: .automatic)
					callback(false)
				} else if let error = response.error {
					self.showErrorAlert(error)
					callback(false)
				}
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			AzureData.delete(self.documents[indexPath.row], databaseId: self.database!.id, collectionId: self.documentCollection!.id) { success in
				if success {
					self.documents.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				callback(success)
			}
		}
		return UISwipeActionsConfiguration(actions: [ action ] );
	}

	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			AzureData.delete(self.documents[indexPath.row], databaseId: self.database!.id, collectionId: self.documentCollection!.id) { success in
				if success {
					self.documents.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return resourceCollectionTitle(section)
	}
	
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return indexPath.section == 0 ? indexPath : nil
	}
	

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? DocumentDetailTableViewController {
			destinationViewController.documentDictionary = documents[index.row].dictionary
		}
    }
}
