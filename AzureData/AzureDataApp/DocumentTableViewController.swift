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
	
	var databaseId: String?
	var documentCollectionId: String?
	
	//var documents:[Person] = []
	//var documents:[CustomDocument] = []
	var documents: [ADDocument] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		refreshData()
		
		navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

	func refreshData() {
		if let database = databaseId, let documentCollection = documentCollectionId {
			//AzureData.documents(Person.self, databaseId: database, collectionId: documentCollection) { list in
			//AzureData.documents(CustomDocument.self, databaseId: database, collectionId: documentCollection) { list in
			AzureData.documents(ADDocument.self, databaseId: database, collectionId: documentCollection) { response in
				print(response.result)
				if let items = response.resource?.items {
					//for item in items { item.printLog()	}
					self.documents = items
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

	
	@IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
	
	
	@IBAction func addButtonTouchUpInside(_ sender: Any) {
		if let databaseId = databaseId, let documentCollectionId = documentCollectionId {
			
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
				} else { response.error?.printLog() }
			}
		}
	}

	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return documents.count }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)

		let document = documents[indexPath.row]
		
		cell.textLabel?.text = document.id
		cell.detailTextLabel?.text = document.resourceId
		
        return cell
    }

	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
			AzureData.document(CustomDocument.self, databaseId: self.databaseId!, collectionId: self.documentCollectionId!, documentId: self.documents[indexPath.row].id) { response in
				debugPrint(response.result)
				response.resource?.printLog()
				tableView.reloadRows(at: [indexPath], with: .automatic)
				callback(false)
			}
		}
		action.backgroundColor = UIColor.blue
		
		return UISwipeActionsConfiguration(actions: [ action ] );
	}
	
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
			AzureData.delete(self.documents[indexPath.row], databaseId: self.databaseId!, collectionId: self.documentCollectionId!) { success in
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
			AzureData.delete(self.documents[indexPath.row], databaseId: self.databaseId!, collectionId: self.documentCollectionId!) { success in
				if success {
					self.documents.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
		}
	}
	

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? DocumentDetailTableViewController {
			destinationViewController.documentDictionary = documents[index.row].dictionary
		}
    }
}
