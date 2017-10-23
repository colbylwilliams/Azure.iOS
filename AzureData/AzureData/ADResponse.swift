//
//  ADResponse.swift
//  AzureData
//
//  Created by Colby Williams on 10/18/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

//public class ADResource {
//	var id: 			String = ""
//	var resourceId: 	String = ""
//	var selfLink: 		String = ""
//	var etag: 			String = ""
//	var timestamp: 		String = ""
//	var attachments: 	String = ""
//	var altLink: 		String = ""
//}

public struct ADResponse<T:ADResource> {
	/// The URL request sent to the server.
	public let request: URLRequest?
	
	/// The server's response to the URL request.
	public let response: HTTPURLResponse?
	
	/// The data returned by the server.
	public let data: Data?
	
	/// The result of response serialization.
	public let result: ADResult<T>
	
	/// Returns the associated value of the result if it is a success, `nil` otherwise.
	public var resource: T? { return result.resource }
	
	/// Returns the associated error value if the result if it is a failure, `nil` otherwise.
	public var error: ADError? { return result.error }
	
	public init(
		request: URLRequest?,
		response: HTTPURLResponse?,
		data: Data?,
		result: ADResult<T>)
	{
		self.request = request
		self.response = response
		self.data = data
		self.result = result
	}
	
	public init (_ error: ADError) {
		self.init(request: nil, response: nil, data: nil, result: .failure(ADError()))
	}
}

public struct ADListResponse<T:ADResource> {
	/// The URL request sent to the server.
	public let request: URLRequest?
	
	/// The server's response to the URL request.
	public let response: HTTPURLResponse?
	
	/// The data returned by the server.
	public let data: Data?
	
	/// The result of response serialization.
	public let result: ADListResult<T>
	
	/// Returns the associated value of the result if it is a success, `nil` otherwise.
	public var resource: ADResourceList<T>? { return result.resource }
	
	/// Returns the associated error value if the result if it is a failure, `nil` otherwise.
	public var error: ADError? { return result.error }
	
	public init(
		request: URLRequest?,
		response: HTTPURLResponse?,
		data: Data?,
		result: ADListResult<T>)
	{
		self.request = request
		self.response = response
		self.data = data
		self.result = result
	}
	
	public init (_ error: ADError) {
		self.init(request: nil, response: nil, data: nil, result: .failure(ADError()))
	}
}


public enum ADResult<T:ADResource> {
	case success(T)
	case failure(ADError)
	
	/// Returns `true` if the result is a success, `false` otherwise.
	public var isSuccess: Bool {
		switch self {
		case .success: return true
		case .failure: return false
		}
	}
	
	/// Returns `true` if the result is a failure, `false` otherwise.
	public var isFailure: Bool {
		return !isSuccess
	}

	/// Returns the associated value if the result is a success, `nil` otherwise.
	public var resource: T? {
		switch self {
		case .success(let resource): return resource
		case .failure: return nil
		}
	}
	
	/// Returns the associated error value if the result is a failure, `nil` otherwise.
	public var error: ADError? {
		switch self {
		case .success: return nil
		case .failure(let error): return error
		}
	}
}


public enum ADListResult<T:ADResource> {
	case success(ADResourceList<T>)
	case failure(ADError)
	
	/// Returns `true` if the result is a success, `false` otherwise.
	public var isSuccess: Bool {
		switch self {
		case .success: return true
		case .failure: return false
		}
	}
	
	/// Returns `true` if the result is a failure, `false` otherwise.
	public var isFailure: Bool {
		return !isSuccess
	}

	/// Returns the associated value if the result is a success, `nil` otherwise.
	public var resource: ADResourceList<T>? {
		switch self {
		case .success(let resource): return resource
		case .failure: return nil
		}
	}
	
	/// Returns the associated error value if the result is a failure, `nil` otherwise.
	public var error: ADError? {
		switch self {
		case .success: return nil
		case .failure(let error): return error
		}
	}
}

// MARK: - CustomStringConvertible

extension ADResult: CustomStringConvertible {
	public var description: String {
		switch self {
		case .success: return "SUCCESS"
		case .failure: return "FAILURE"
		}
	}
}

extension ADListResult: CustomStringConvertible {
	public var description: String {
		switch self {
		case .success: return "SUCCESS"
		case .failure: return "FAILURE"
		}
	}
}


// MARK: - CustomDebugStringConvertible

extension ADResult: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .success(let value): return "SUCCESS: \(value)"
		case .failure(let error): return "FAILURE: \(error)"
		}
	}
}

extension ADListResult: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .success(let value): return "SUCCESS: \(value)"
		case .failure(let error): return "FAILURE: \(error)"
		}
	}
}

