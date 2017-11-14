//
//  Response.swift
//  AzureData iOS
//
//  Created by Colby Williams on 11/11/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct Response<T:CodableResource> {
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let data: Data?
    
    public let result: Result<T>
    
    public var resource: T? { return result.resource }
    
    public var error: ADError? { return result.error }
    
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: Result<T>)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
    
    public init (_ error: ADError) {
        self.init(request: nil, response: nil, data: nil, result: .failure(error))
    }
}

public struct ListResponse<T:CodableResource> {
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let data: Data?
    
    public let result: ListResult<T>
    
    public var resource: Resources<T>? { return result.resource }
    
    public var error: ADError? { return result.error }
    
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: ListResult<T>)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
    
    public init (_ error: ADError) {
        self.init(request: nil, response: nil, data: nil, result: .failure(error))
    }
}

public struct DataResponse {
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public var data: Data? { return result.resource }
    
    public let result: DataResult
    
    public var error: ADError? { return result.error }
    
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: DataResult)
    {
        self.request = request
        self.response = response
        self.result = result
    }
    
    public init (_ error: ADError) {
        self.init(request: nil, response: nil, data: nil, result: .failure(error))
    }
}


public enum Result<T:CodableResource> {
    case success(T)
    case failure(ADError)
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var resource: T? {
        switch self {
        case .success(let resource): return resource
        case .failure: return nil
        }
    }
    
    public var error: ADError? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

public enum DataResult {
    case success(Data)
    case failure(ADError)
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var resource: Data? {
        switch self {
        case .success(let resource): return resource
        case .failure: return nil
        }
    }
    
    public var error: ADError? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

public enum ListResult<T:CodableResource> {
    case success(Resources<T>)
    case failure(ADError)
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var resource: Resources<T>? {
        switch self {
        case .success(let resource): return resource
        case .failure: return nil
        }
    }
    
    public var error: ADError? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

// MARK: - CustomStringConvertible

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success: return "SUCCESS"
        case .failure: return "FAILURE"
        }
    }
}

extension ListResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success: return "SUCCESS"
        case .failure: return "FAILURE"
        }
    }
}


// MARK: - CustomDebugStringConvertible

extension Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value): return "SUCCESS: \(value)"
        case .failure(let error): return "FAILURE: \(error)"
        }
    }
}

extension ListResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value): return "SUCCESS: \(value)"
        case .failure(let error): return "FAILURE: \(error)"
        }
    }
}
