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
    
    func showErrorAlert (_ error: Error) {
        
        var title = "Error"
        var message = error.localizedDescription
        
        if let documentError = error as? DocumentClientError {
            title += ": \(documentError.kind)"
            message = documentError.message ?? documentError.localizedDescription
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true) { }
    }
}
