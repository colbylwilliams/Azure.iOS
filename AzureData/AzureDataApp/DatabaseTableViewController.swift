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

		AzureData.setup("mobile", key: "Np4cUd6IO3rFM6EMMoXBeGv4LKVrkfFDmws51nBpDFypym90IVPdjMQcy6SjmFMJklTwWglBhSAtoK07IwK7kg==", keyType: .master)
		
		AzureData.databases { list in
			if let dbs = list?.items {
				self.databases = dbs
				self.tableView.reloadData()
			} else {
				print("poop")
			}
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "databaseCell", for: indexPath)
		
		let database = databases[indexPath.row]
		
		cell.textLabel?.text = database.id
		cell.detailTextLabel?.text = database.resourceId

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

	
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let destinationViewController = segue.destination as? CollectionTableViewController {
			destinationViewController.databaseId = databases[index.row].id
		}
    }
}
