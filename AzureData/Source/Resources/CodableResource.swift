//
//  CodableResource.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public protocol CodableResource : Codable {
    
    static var type:String  { get }
    static var list:String  { get }
    
    var id:         String  { get }
    var resourceId: String  { get }
    var selfLink:   String? { get }
    var etag:       String? { get }
    var timestamp:  Date?   { get }
}

extension CodableResource {
    
    public static func fragment (_ resourceId: String? = nil) -> String {
        return resourceId.isNilOrEmpty ? Self.type : "\(Self.type)/\(resourceId!)"
    }
    
    public static func path (fromParent parentPath: String? = nil, resourceId: String? = nil) -> String {
        return parentPath.isNilOrEmpty ? fragment(resourceId) : "\(parentPath!)/\(fragment(resourceId))"
    }
    
    public static func link (fromParentPath parentPath: String? = nil, resourceId: String? = nil) -> String {
        return resourceId.isNilOrEmpty ? parentPath ?? "" : path(fromParent: parentPath, resourceId: resourceId)
    }
    
    public static func link (fromParentSelfLink parentSelf: String, resourceId: String? = nil) -> String {
        return resourceId.isNilOrEmpty ? String((parentSelf).split(separator: "/").last!).lowercased() : resourceId!.lowercased()
    }
    
    func resourceUri (forHost host: String) -> (URL, String)? {
        return self.selfLink.isNilOrEmpty ? nil : (URL(string: "\(host)/\(self.selfLink!)")!, self.resourceId.lowercased())
    }
//    public var link: String {
//        self.selfLink?.split(separator: "/")
//        // dbs/TC1AAA==/colls/TC1AAMDvwgA=/docs/TC1AAMDvwgBQAAAAAAAAAA==/
//    }
    
    public static func url (atHost host: String, at path: String = Self.type) -> URL? {
        return URL(string: "https://\(host)/\(path)")
    }
}
