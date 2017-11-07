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
    
    var database: ADDatabase!
    var collection: ADCollection!
    
    var documents: [ADDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

    
    func refreshData() {
        
        collection.get(documentsAs: ADDocument.self) { response in
            debugPrint(response.result)
            if let items = response.resource?.items {
                self.documents = items
                self.reloadOnMainThread()
            } else if let error = response.error {
                self.showErrorAlert(error)
            }
            DispatchQueue.main.async {
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
    }

    
    func reloadOnMainThread() { DispatchQueue.main.async { self.tableView.reloadData() } }
    
    
    @IBAction func refreshControlValueChanged(_ sender: Any) { refreshData() }
    
    
    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        
//        let query =  ADQuery.select()
//                            .from(collection.id)
//                            .where("firstName", is: "Colby")
//                            .and("lastName", is: "Williams")
//                            .and("age", isGreaterThanOrEqualTo: 20)
//                            .orderBy("_etag", descending: true)
//        
        //AzureData.query(query(documentsIn: collection.id, inDatabase: database.id, with: query) { r in
//        collection.queryDocuments(with: query) { r in
//            debugPrint(r.result)
//            if let items = r.resource?.items {
//                for item in items { item.printLog() }
//            } else if let error = r.error {
//                self.showErrorAlert(error)
//            }
//        }
//        
//        return
        
        let doc = ADDocument()
        
        doc["testNumber"] = 1_000_000
        doc["testString"] = "Yeah baby\nRock n Roll"
        doc["testDate"]   = Date().timeIntervalSince1970
        
        //AzureData.createDocument(database.id, collectionId: collection.id, document: doc) { r in
        collection.create(doc) { r in
            debugPrint(r.result)
            if let document = r.resource {
                self.documents.append(document)
                self.reloadOnMainThread()
            } else if let error = r.error {
                self.showErrorAlert(error)
            }
        }
    }
    
    
    func showErrorAlert (_ error: ADError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true) { }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return documents.count }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)

        let resource = documents[indexPath.row]
        
        cell.textLabel?.text = resource.id
        cell.detailTextLabel?.text = resource.resourceId
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction.init(style: .normal, title: "Get") { (action, view, callback) in
            //AzureData.get(documentWithId: self.documents[indexPath.row].id, as: ADDocument.self, inCollection: collection.id, inDatabase: database.id) { r in
            self.collection.get(documentWithResourceId: self.documents[indexPath.row].resourceId, as: ADDocument.self) { r in
                if r.result.isSuccess {
                    debugPrint(r.result)
                    r.resource?.printLog()
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                        callback(false)
                    }
                } else if let error = r.error {
                    self.showErrorAlert(error)
                    DispatchQueue.main.async { callback(false) }
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
        //AzureData.delete(documents[indexPath.row], fromCollection: collection.id, inDatabase: database.id) { success in
        collection.delete(documents[indexPath.row]) { success in
            if success {
                self.documents.remove(at: indexPath.row)
                DispatchQueue.main.async { tableView.deleteRows(at: [indexPath], with: .automatic) }
            }
            DispatchQueue.main.async { callback?(success) }
        }
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
