//
//  Query.swift
//  AzureData
//
//  Created by Colby Williams on 11/13/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class Query : Encodable {
    
    fileprivate var selectCalled    = false
    fileprivate var fromCalled      = false
    fileprivate var whereCalled     = false
    fileprivate var andCalled       = false
    fileprivate var orderByCalled   = false
    
    fileprivate var selectProperties:   [String] = []
    fileprivate var fromFragment:        String?
    fileprivate var whereFragment:       String?
    fileprivate var andFragments:       [String] = []
    fileprivate var orderByFragment:     String?
    
    fileprivate var type:       String?
    
    private enum CodingKeys: String, CodingKey {
        case query
        case parameters
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(query, forKey: .query)
        try container.encode(parameters.isEmpty ? [] : [parameters], forKey: .parameters)
    }
    
    init(_ properties: [String]? = nil) {
        selectCalled = true
        
        if let properties = properties, !properties.isEmpty {
            self.selectProperties = properties
        }
    }
    
    public static func select() -> Query {
        //assert(!selectCalled, "you can only call select once")
        //selectCalled = true;
        
        return Query()
    }
    
    public static func select(_ properties: String...) -> Query {
        //        assert(selectCalled, "you can only call `select` once")
        //        selectCalled = true;
        
        //        self.selectProperties = properties
        
        return Query()
    }
    
    
    
    public var query : String {
        
        var query = ""
        
        if selectCalled && fromCalled && !type.isNilOrEmpty  {
            
            let selectFragment = selectProperties.isEmpty ? "*" : "\(type!)." + selectProperties.joined(separator: ", \(type!).")
            
            //fromFragment = type!
            
            query = "SELECT \(selectFragment) FROM \(type!)"
            
            if whereCalled && !whereFragment.isNilOrEmpty {
                
                query += " WHERE \(type!).\(whereFragment!)"
                
                if andCalled && !andFragments.isEmpty {
                    query += " AND \(type!)."
                    query += andFragments.joined(separator: " AND \(type!).")
                }
            }
            
            if orderByCalled && !orderByFragment.isNilOrEmpty {
                
                query += " ORDER BY \(type!).\(orderByFragment!)"
            }
        }
        
        return query
    }
    
    public var parameters: [String:String] {
        return [:]
    }
    
    public var dictionary: [String: Any] {
        return [
            "query": query,
            "parameters": parameters.isEmpty ? [] : [parameters]
        ]
    }
    
    
    
    public func printQuery() {
        print(query)
    }
}

extension Query {
    
    public func from(_ type: String) -> Query {
        assert(selectCalled, "must call `select` before calling `from`")
        assert(!fromCalled, "you can only call `from` once")
        fromCalled = true;
        
        self.type = type
        
        return self
    }
    
    public func `where`(_ property: String, is value: String) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) = '\(value)'"
        
        return self
    }
    
    public func `where`(_ property: String, is value: Int) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) = \(value)"
        
        return self
    }
    
    public func `where`(_ property: String, isNot value: String) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) != '\(value)'"
        
        return self
    }
    
    public func `where`(_ property: String, isNot value: Int) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) != \(value)"
        
        return self
    }
    
    public func `where`(_ property: String, isGreaterThan value: String) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) > '\(value)'"
        
        return self
    }
    
    public func `where`(_ property: String, isGreaterThan value: Int) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) > \(value)"
        
        return self
    }
    
    public func `where`(_ property: String, isLessThan value: String) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) < '\(value)'"
        
        return self
    }
    
    public func `where`(_ property: String, isLessThan value: Int) -> Query {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) < \(value)"
        
        return self
    }
    
    
    public func and(_ property: String, is value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) = '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, is value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) = \(value)")
        
        return self
    }
    
    public func and(_ property: String, isNot value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) != '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isNot value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) != \(value)")
        
        return self
    }
    
    public func and(_ property: String, isGreaterThan value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) > '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isGreaterThan value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) > \(value)")
        
        return self
    }
    
    public func and(_ property: String, isGreaterThanOrEqualTo value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) >= '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isGreaterThanOrEqualTo value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) >= \(value)")
        
        return self
    }
    
    public func and(_ property: String, isLessThan value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) < '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isLessThan value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) < \(value)")
        
        return self
    }
    
    public func and(_ property: String, isLessThanOrEqualTo value: String) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) <= '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isLessThanOrEqualTo value: Int) -> Query {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) <= \(value)")
        
        return self
    }
    
    public func orderBy(_ property: String, descending: Bool = false) -> Query {
        assert(!orderByCalled, "you can only call `orderBy` once, to order on an additional level use `thenBy`")
        orderByFragment = property
        
        if descending { orderByFragment! += " DESC" }
        
        return self
    }
}
