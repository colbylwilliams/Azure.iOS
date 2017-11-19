//
//  ResourceCache.swift
//  AzureData
//
//  Created by Colby L Williams on 11/18/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public extension DocumentClient {
    
    public func cache<T:CodableResource>(_ resource: T) {
        
        // get the documents folder url
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory.appendingPathComponent(resource.selfLink!).appendingPathExtension(".json")


        do {
            
            let json = try self.jsonEncoder.encode(resource)
            
            try json.write(to: fileURL, options: .atomic)
            
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
}
