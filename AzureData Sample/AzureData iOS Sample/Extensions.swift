//
//  Extensions.swift
//  AzureData iOS Sample
//
//  Created by Colby Williams on 11/15/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation
import UIKit
import AzureData

extension UITableViewController {
    
    func showErrorAlert (_ error: DocumentClientError) {
        let alertController = UIAlertController(title: "Error: \(error.code)", message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true) { }
    }
}
