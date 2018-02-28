//
//  Models.swift
//  AzureDataApp
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AzureData

class CustomDocument: ADDocument {
    
}

class Person: ADDocument {
    
    var firstName:  String = ""
    var lastName:   String = ""
    var age:        Int    = 0
    var email:      String = ""

    
    override var dictionary: [String : Any] {
        return super.dictionary.merging([
            "firstName":firstName,
            "lastName":lastName,
            "age":age,
            "email":email])
        { (_, new) in new }
    }
    
    required init?(fromJson dict: [String : Any]) {
        super.init(fromJson: dict)
        
        if let firstName = dict["firstName"] as? String { self.firstName = firstName }
        if let lastName = dict["lastName"] as? String { self.lastName = lastName }
        if let age = dict["age"] as? Int { self.age = age }
        if let email = dict["email"] as? String { self.email = email }
    }
    
//  override func printPretty() {
//      print("Person")
//      super.printPretty()
//      print("\tfirstName: \(firstName)")
//      print("\tlastName: \(lastName)")
//      print("\tage: \(age)")
//      print("\temail: \(email)")
//  }
}
