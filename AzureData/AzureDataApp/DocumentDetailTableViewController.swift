//
//  DocumentDetailTableViewController.swift
//  AzureDataApp
//
//  Created by Colby Williams on 10/20/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import UIKit

class DocumentDetailTableViewController: UITableViewController {

	var documentDictionaryKeys: [String] = []
	var documentDictionaryValues: [Any]  = []
	
	var documentDictionary: [String:Any] = [:] {
		willSet {
			documentDictionaryKeys = []
			documentDictionaryValues = []
			
			for item in newValue {
				documentDictionaryKeys.append(item.key)
				documentDictionaryValues.append(item.value)
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }

	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return documentDictionary.count }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentDetailCell", for: indexPath)

		cell.textLabel?.text = documentDictionaryKeys[indexPath.row]
		cell.detailTextLabel?.text = "\(documentDictionaryValues[indexPath.row])"

        return cell
    }
}

