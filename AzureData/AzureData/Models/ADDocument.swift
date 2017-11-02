//
//  ADDocument.swift
//  AzureData
//
//  Created by Colby Williams on 10/19/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

open class ADDocument: ADResource {
    
    var baseKeys = [ADResource.idKey,
                    ADResource.resourceIdKey,
                    ADResource.selfLinkKey,
                    ADResource.etagKey,
                    ADResource.timestampKey,
                    ADDocument.attachmentsLinkKey ]
    
    static let attachmentsLinkKey   = "_attachments"
    
    public private(set) var attachmentsLink: String?
    
    var data: [String:Any] = [:]
    
    
    public override init() { super.init() }
    
    public override init(_ id: String) { super.init(id) }
    
    required public init?(fromJson dict: [String:Any]) {
        super.init(fromJson: dict)
        
        attachmentsLink = dict[ADDocument.attachmentsLinkKey] as? String
        
        data = dict.filter{ x in !baseKeys.contains(x.key) }
    }
    
    open override var dictionary: [String : Any] {
        return super.dictionary.merging([
            ADDocument.attachmentsLinkKey:attachmentsLink.valueOrEmpty])
        { (_, new) in new }.merging(data)
        { (_, new) in new }
    }
    
    public subscript(key: String) -> Any? {
        get {
            return data[key]
        }
        set {

            if newValue == nil { data[key] = newValue; return }
            
            assert(!baseKeys.contains(key), "Error: Subscript cannot be used to set the following system generated properties: \(baseKeys.joined(separator: ", "))\n")
            assert(newValue is NSString || newValue is NSNumber || newValue is NSNull, "Error: Value for `\(key)` is not a primitive type.  Only primitive types can be stored with subscript.\n")

            //guard !baseKeys.contains(key) else { return }
            
            data[key] = newValue
        }
    }
    
    
    func printData() { for item in data { print(item) } }
}
