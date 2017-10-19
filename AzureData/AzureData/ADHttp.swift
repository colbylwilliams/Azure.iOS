//
//  ADHttp.swift
//  AzureData
//
//  Created by Colby Williams on 10/18/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

// https://docs.microsoft.com/en-us/rest/api/documentdb/http-status-codes-for-documentdb
public enum ADStatusCode : Int {
	case ok                     = 200
	case created                = 201
	case noContent              = 204
	case badRequest             = 400
	case unauthorized           = 401
	case forbidden              = 403
	case notFound               = 404
	case requestTimeout         = 408
	case conflict               = 409
	case preconditionFailure    = 412
	case entityTooLarge         = 413
	case tooManyRequests        = 429
	case retryWith              = 449
	case internalServerError    = 500
	case serviceUnavailable     = 503
}

public enum ADHttpMethod : String {
	case get     = "GET"
	case head    = "HEAD"
	case post    = "POST"
	case put     = "PUT"
	case delete  = "DELETE"
}

// https://docs.microsoft.com/en-us/rest/api/documentdb/common-documentdb-rest-request-headers
public enum ADHttpRequestHeader {
	case authorization
	case contentType
	case ifMatch
	case ifNoneMatch
	case ifModifiedSince
	case userAgent
	case xMSActivityId
	case xMSConsistencyLevel
	case xMSContinuation
	case xMSDate
	case xMSMaxItemCount
	case xMSDocumentdbPartitionkey
	case xMSSessionToken
	case xMSVersion
	case aIM
	case xMSDocumentdbPartitionKeyRangeId
	case acceptEncoding
	case acceptLanguage
	
	var key: String {
		switch self {
		case .authorization: 					return "Authorization"
		case .contentType:						return "Content-Type"
		case .ifMatch: 							return "If-Match"
		case .ifNoneMatch: 						return "If-None-Match"
		case .ifModifiedSince: 					return "If-Modified-Since"
		case .userAgent: 						return "User-Agent"
		case .xMSActivityId: 					return "x-ms-activity-id"
		case .xMSConsistencyLevel: 				return "x-ms-consistency-level"
		case .xMSContinuation: 					return "x-ms-continuation"
		case .xMSDate: 							return "x-ms-date"
		case .xMSMaxItemCount: 					return "x-ms-max-item-count"
		case .xMSDocumentdbPartitionkey: 		return "x-ms-documentdb-partitionkey"
		case .xMSSessionToken: 					return "x-ms-session-token"
		case .xMSVersion: 						return "x-ms-version"
		case .aIM: 								return "A-IM"
		case .xMSDocumentdbPartitionKeyRangeId: return "x-ms-documentdb-partitionkeyrangeid"
		case .acceptEncoding:					return "Accept-Encoding"
		case .acceptLanguage:					return "Accept-Language"
		}
	}
	
	var required: Bool {
		switch self {
		case .authorization,
		     .contentType,
		     .xMSDate,
		     .xMSSessionToken,
		     .xMSVersion: return true
		default: return false
		}
	}
}

extension Dictionary where Key == ADHttpRequestHeader, Value == String  {
	var strings: [String:String] {
		return Dictionary<String, String>.init(uniqueKeysWithValues: self.map{ (k, v) in
			(k.key, v)
		})
	}
}


// https://docs.microsoft.com/en-us/rest/api/documentdb/common-documentdb-rest-response-headers
public enum ADResponseHeader {
	
}


extension URLRequest {
	mutating func addValue(_ value: String, forHTTPHeaderField: ADHttpRequestHeader) {
		self.addValue(value, forHTTPHeaderField: forHTTPHeaderField.key)
	}
	
	var method: ADHttpMethod? {
		get {
			if let m = self.httpMethod, let adM = ADHttpMethod(rawValue: m) {
				return adM
			}
			return nil
		}
		set {
			self.httpMethod = newValue?.rawValue
		}
	}
}


//enum AMResourceUri {
//    case database(String, String)                           //= "https://{databaseaccount}.documents.azure.com/dbs/{db}"
//    case user(String, String, String)                       //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/users/{user}"
//    case permission(String, String, String, String)         //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/users/{user}/permissions/{perm}"
//    case collection(String, String, String)                 //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}"
//    case storedProcedure(String, String, String, String)    //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}/sprocs/{sproc}"
//    case trigger(String, String, String, String)            //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}/triggers/{trigger}"
//    case udf(String, String, String, String)                //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}/udfs/{udf}"
//    case document(String, String, String, String)           //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}/docs/{doc}"
//    case attachment(String, String, String, String, String) //= "https://{databaseaccount}.documents.azure.com/dbs/{db}/colls/{coll}/docs/{doc}/attachments/{attch}"
//    case offer(String, String)                              //= "https://{databaseaccount}.documents.azure.com/offers/{offer}"
//}
