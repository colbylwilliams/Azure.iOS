//
//  ADQuery.swift
//  AzureData
//
//  Created by Colby Williams on 10/23/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class ADQuery {
    
    var selectCalled    = false
    var fromCalled      = false
    var whereCalled     = false
    var andCalled       = false
    var orderByCalled   = false
    
    var selectProperties:   [String] = []
    var fromFragment:        String?
    var whereFragment:       String?
    var andFragments:       [String] = []
    var orderByFragment:     String?
    
    var type:       String?
    
    init(_ properties: [String]? = nil) {
        selectCalled = true
        
        if let properties = properties, !properties.isEmpty {
            self.selectProperties = properties
        }
    }
    
    public static func select() -> ADQuery {
        //assert(!selectCalled, "you can only call select once")
        //selectCalled = true;
        
        return ADQuery()
    }

    public static func select(_ properties: String...) -> ADQuery {
//        assert(selectCalled, "you can only call `select` once")
//        selectCalled = true;

//        self.selectProperties = properties
        
        return ADQuery()
    }

    public func from(_ type: String) -> ADQuery {
        assert(selectCalled, "must call `select` before calling `from`")
        assert(!fromCalled, "you can only call `from` once")
        fromCalled = true;

        self.type = type
        
        return self
    }
    
    public func `where`(_ property: String, is value: String) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) = '\(value)'"
        
        return self
    }

    public func `where`(_ property: String, is value: Int) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) = \(value)"
        
        return self
    }

    public func `where`(_ property: String, isNot value: String) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) != '\(value)'"
        
        return self
    }

    public func `where`(_ property: String, isNot value: Int) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) != \(value)"
        
        return self
    }

    public func `where`(_ property: String, isGreaterThan value: String) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) > '\(value)'"
        
        return self
    }

    public func `where`(_ property: String, isGreaterThan value: Int) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) > \(value)"
        
        return self
    }

    public func `where`(_ property: String, isLessThan value: String) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) < '\(value)'"
        
        return self
    }

    public func `where`(_ property: String, isLessThan value: Int) -> ADQuery {
        assert(!whereCalled, "you can only call `where` once, to add more constraints use `and`")
        whereCalled = true
        
        whereFragment = "\(property) < \(value)"
        
        return self
    }

    
    public func and(_ property: String, is value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) = '\(value)'")
        
         return self
    }

    public func and(_ property: String, is value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) = \(value)")
        
        return self
    }

    public func and(_ property: String, isNot value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) != '\(value)'")
        
        return self
    }

    public func and(_ property: String, isNot value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) != \(value)")
        
        return self
    }

    public func and(_ property: String, isGreaterThan value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) > '\(value)'")
        
        return self
    }

    public func and(_ property: String, isGreaterThan value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) > \(value)")
        
        return self
    }

    public func and(_ property: String, isGreaterThanOrEqualTo value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) >= '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isGreaterThanOrEqualTo value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) >= \(value)")
        
        return self
    }

    public func and(_ property: String, isLessThan value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) < '\(value)'")
        
        return self
    }

    public func and(_ property: String, isLessThan value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) < \(value)")
        
        return self
    }

    public func and(_ property: String, isLessThanOrEqualTo value: String) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) <= '\(value)'")
        
        return self
    }
    
    public func and(_ property: String, isLessThanOrEqualTo value: Int) -> ADQuery {
        assert(whereCalled, "must call where before calling and")
        andCalled = true
        
        andFragments.append("\(property) <= \(value)")
        
        return self
    }

    public func orderBy(_ property: String, descending: Bool = false) -> ADQuery {
        assert(!orderByCalled, "you can only call `orderBy` once, to order on an additional level use `thenBy`")
        orderByFragment = property
        
        if descending { orderByFragment! += " DESC" }
        
         return self
    }
    
    
    public var query:String {
        
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
            "parameters":parameters.isEmpty ? [] : [parameters]
        ]
    }
    
    public func printQuery() {
        print(query)
    }
}
