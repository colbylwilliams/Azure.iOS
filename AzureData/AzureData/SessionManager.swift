//
//  SessionManager.swift
//  AzureData
//
//  Created by Colby Williams on 10/18/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

open class SessionManager {
	
	open static let `default`: SessionManager = {
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
		
		return SessionManager(configuration: configuration)
		//return SessionManager()
	}()
	
	
	public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default/*, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil*/)
	{
		//self.delegate = delegate
		self.session = URLSession.init(configuration: configuration)
		//self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
		
		//commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
	}
	
	public var setup = false
	
	var resourceName: String!
	var tokenProvider: ADTokenProvider!
	
	public func setup (_ name: String, key: String, keyType: ADTokenType) {
		resourceName = name
		tokenProvider = ADTokenProvider(key: key, keyType: keyType, tokenVersion: "1.0")
		setup = true
	}

	
	/// Creates default values for the "Accept-Encoding", "Accept-Language", "User-Agent", and "x-ms-version" headers.
	static let defaultHTTPHeaders: HTTPHeaders = {
		// https://docs.microsoft.com/en-us/rest/api/documentdb/#supported-rest-api-versions
		let apiVersion = "2017-02-22"
		
		// Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
		let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
		
		// Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
		let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
			let quality = 1.0 - (Double(index) * 0.1)
			return "\(languageCode);q=\(quality)"
			}.joined(separator: ", ")
		
		// User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
		// Example: `iOS Example/1.1.0 (com.colbylwilliams.azuredata; build:23; iOS 10.0.0) AzureData/2.0.0`
		let userAgent: String = {
			if let info = Bundle.main.infoDictionary {
				let executable = 	info[kCFBundleExecutableKey as String] 	as? String ?? "Unknown" // iOS Example
				let bundle = 		info[kCFBundleIdentifierKey as String] 	as? String ?? "Unknown" // com.colbylwilliams.azuredata
				let appVersion = 	info["CFBundleShortVersionString"] 		as? String ?? "Unknown" // 1.1.0
				let appBuild = 		info[kCFBundleVersionKey as String] 	as? String ?? "Unknown" // 23
				
				let osNameVersion: String = {
					let version = ProcessInfo.processInfo.operatingSystemVersion
					let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)" // 10.0.0
					
					let osName: String = {
						#if os(iOS)
							return "iOS"
						#elseif os(watchOS)
							return "watchOS"
						#elseif os(tvOS)
							return "tvOS"
						#elseif os(macOS)
							return "OS X"
						#elseif os(Linux)
							return "Linux"
						#else
							return "Unknown"
						#endif
					}()
					
					return "\(osName) \(versionString)" // iOS 10.0.0
				}()
				
				let azureDataVersion: String = {
					guard
						let adInfo = Bundle(for: SessionManager.self).infoDictionary,
						let build = adInfo["CFBundleShortVersionString"]
						else { return "Unknown" }
					
					return "AzureData/\(build)" // AzureData/2.0.0
				}()
				
				print("\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(azureDataVersion)")
				return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(azureDataVersion)"
			}
			
			return "AzureData"
		}()
		
		let dict: [ADHttpRequestHeader:String] = [
			.acceptEncoding: acceptEncoding,
			.acceptLanguage: acceptLanguage,
			.userAgent: userAgent,
			.xMSVersion: apiVersion
		]
		
		return dict.strings
	}()
	
	
	/// The underlying session.
	open let session: URLSession

	
	public func delete (_ resourceType: ADResourceType, resourceId: String, parentId: String? = nil, grandparentId: String? = nil, greatgrandparentId: String? = nil, callback: @escaping (Bool) -> ()) {
		
		let uri = ADResourceUri(resourceName)
		
		var resourceUri: (URL, String)?
		
		switch resourceType {
		case .database: 		resourceUri = uri.database(resourceId)
		case .user: 			resourceUri = uri.user(parentId!, userId: resourceId)
		case .permission: 		resourceUri = uri.permission(grandparentId!, userId: parentId!, permissionId: resourceId)
		case .collection: 		resourceUri = uri.collection(parentId!, collectionId: resourceId)
		case .storedProcedure: 	resourceUri = uri.storedProcedure(grandparentId!, collectionId: parentId!, storedProcedureId: resourceId)
		case .trigger: 			resourceUri = uri.trigger(grandparentId!, collectionId: parentId!, triggerId: resourceId)
		case .udf: 				resourceUri = uri.udf(grandparentId!, collectionId: parentId!, udfId: resourceId)
		case .document: 		resourceUri = uri.document(grandparentId!, collectionId: parentId!, documentId: resourceId)
		case .attachment: 		resourceUri = uri.attachment(greatgrandparentId!, collectionId: grandparentId!, documentId: parentId!, attachmentId: resourceId)
		case .offer: 			resourceUri = uri.offer(resourceId)
		}
		
		if let resourceUri = resourceUri {
			return delete(resourceUri: resourceUri, resourceType: resourceType, callback: callback)
		} else {
			DispatchQueue.main.async { callback(false) }
		}
	}

	
	
	// MARK: - Databases

	// create
	public func createDatabase (_ databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).database()
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: ["id":databaseId], options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .database, httpBody: httpBody, callback: callback)
	}

	// list
	public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).database()
		
		return resources(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// get
	public func database (_ databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).database(databaseId)
		
		return resource(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// delete
	public func delete (_ resource: ADDatabase, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).database(resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}
	
	
	
	// MARK: - DocumentCollections
	
	// create
	public func createDocumentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).collection(databaseId)
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: ["id":collectionId], options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .collection, httpBody: httpBody, callback: callback)
	}

	// list
	public func documentCollections (_ databaseId: String, callback: @escaping (ADListResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).collection(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// get
	public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).collection(databaseId, collectionId: collectionId)
		
		return resource(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// delete
	public func delete (_ resource: ADDocumentCollection, databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).collection(databaseId, collectionId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// replace
	
	
	
	// MARK: - Documents
	
	// create
	public func createDocument<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId)
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: document.dictionary, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
	}

	// list
	public func documents<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, callback: @escaping (ADListResponse<T>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

	// get
	public func document<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADResponse<T>) -> ()) {

		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId, documentId: documentId)
		
		return resource(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

	// delete
	public func delete (_ resource: ADDocument, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId, documentId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

	// replace
	public func replace<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId, documentId: document.id)
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: document.dictionary, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
	}

	// query
	
	
	
	// MARK: - Attachments
	
	// create
	
	// list
	public func attachments (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).attachment(databaseId, collectionId: collectionId, documentId: documentId)
		
		return resources(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// delete
	public func delete (_ resource: ADAttachment, databaseId: String, collectionId: String, documentId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// replace
	
	
	
	// MARK: - Stored Procedures
	
	// create
	
	// list
	public func storedProcedures (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).storedProcedure(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

	// delete
	public func delete (_ resource: ADStoredProcedure, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

	// replace
	
	// execute
	
	
	
	// MARK: - User Defined Functions
	
	// create
	
	// list
	public func userDefinedFunctions (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).udf(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

	// delete
	public func delete (_ resource: ADUserDefinedFunction, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).udf(databaseId, collectionId: collectionId, udfId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

	// replace
	
	
	
	
	// MARK: - Triggers
	
	// create
	
	// list
	public func triggers (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).trigger(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

	// delete
	public func delete (_ resource: ADTrigger, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).trigger(databaseId, collectionId: collectionId, triggerId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

	// replace

	
	
	
	// MARK: - Users
	
	// create
	public func createUser (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).user(databaseId)
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: ["id":userId], options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .user, httpBody: httpBody, callback: callback)
	}

	// list
	public func users (_ databaseId: String, callback: @escaping (ADListResponse<ADUser>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).user(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// get
	public func user (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).user(databaseId, userId: userId)
		
		return resource(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// delete
	public func delete (_ resource: ADUser, databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).user(databaseId, userId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// replace

	
	
	
	// MARK: - Permissions
	
	// create
	
	// list
	public func permissions (_ databaseId: String, userId: String, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).permission(databaseId, userId: userId)
		
		return resources(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// get
	public func permission (_ databaseId: String, userId: String, permissionId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).permission(databaseId, userId: userId, permissionId: permissionId)
		
		return resource(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// delete
	public func delete (_ resource: ADPermission, databaseId: String, userId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).permission(databaseId, userId: userId, permissionId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// replace
	
	
	
	
	// MARK: - Offers
	
	// list
	public func offers (callback: @escaping (ADListResponse<ADOffer>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).offer()
		
		return resources(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// get
	public func offer (_ offerId: String, callback: @escaping (ADResponse<ADOffer>) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).offer(offerId)
		
		return resource(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// replace
	// query
	

	

	// MARK: - Resources
	
	// create
	fileprivate func create<T> (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, callback: @escaping (ADResponse<T>) -> ()) {
		
		var request = dataRequest(.post, resourceUri: resourceUri, resourceType: resourceType)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}
	
	// list
	fileprivate func resources<T> (resourceUri: (URL, String), resourceType: ADResourceType, callback: @escaping (ADListResponse<T>) -> ()) {

		let request = dataRequest(.get, resourceUri: resourceUri, resourceType: resourceType)
		
		return sendRequest(request, resourceType: resourceType, callback: callback)
	}
	
	// get
	fileprivate func resource<T>(resourceUri: (URL, String), resourceType: ADResourceType, callback: @escaping (ADResponse<T>) -> ()) {
		
		let request = dataRequest(.get, resourceUri: resourceUri, resourceType: resourceType)
		
		return sendRequest(request, callback: callback)
	}

	// delete
	fileprivate func delete(resourceUri: (URL, String), resourceType: ADResourceType, callback: @escaping (Bool) -> ()) {
		
		let request = dataRequest(.delete, resourceUri: resourceUri, resourceType: resourceType)
		
		return sendRequest(request, callback: callback)
	}
	
	// replace
	fileprivate func replace<T> (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, callback: @escaping (ADResponse<T>) -> ()) {
		
		var request = dataRequest(.put, resourceUri: resourceUri, resourceType: resourceType)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}

	
	
	
	// MARK: - Request
	
	fileprivate func sendRequest<T> (_ request:URLRequest, callback: @escaping (ADResponse<T>) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
				DispatchQueue.main.async { callback(ADResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error:error)))) }
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				print(json)
				
				var result: ADResult<T>?
				
				if let resource = T(fromJson: json) {
					result = .success(resource)
				} else if let adError = ADError(fromJson: json) {
					result = .failure(adError)
				}
				
				if let result = result {
					DispatchQueue.main.async { callback(ADResponse(request: request, response: response as? HTTPURLResponse, data: data, result: result)) }
				} else {
					DispatchQueue.main.async { callback(ADResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError()))) }
				}
			} else {
				DispatchQueue.main.async { callback(ADResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError()))) }
			}
		}.resume()
	}

	
	fileprivate func sendRequest<T> (_ request:URLRequest, resourceType: ADResourceType, callback: @escaping (ADListResponse<T>) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
				
				DispatchQueue.main.async { callback(ADListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error:error)))) }
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				print(json)
				
				var result: ADListResult<T>?
				
				if let resource = ADResourceList<T>(resourceType, json: json) {
					result = .success(resource)
				} else if let adError = ADError(fromJson: json) {
					result = .failure(adError)
				}

				if let result = result {
					DispatchQueue.main.async { callback(ADListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: result)) }
				} else {
					DispatchQueue.main.async { callback(ADListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError()))) }
				}
			} else {
				DispatchQueue.main.async { callback(ADListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError()))) }
			}
		}.resume()
	}

	
	fileprivate func sendRequest (_ request:URLRequest, callback: @escaping (Bool) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
				DispatchQueue.main.async { callback(false) }
			} else {
				DispatchQueue.main.async { callback(true) }
			}
		}.resume()
	}

	
	fileprivate func dataRequest(_ method: ADHttpMethod, resourceUri: (url:URL, link:String), resourceType: ADResourceType) -> URLRequest {
		
		let (token, date) = tokenProvider.getToken(verb: method, resourceType: resourceType, resourceLink: resourceUri.link)
		
		var request = URLRequest(url: resourceUri.url)
		
		request.method = method
		
		request.addValue(date, forHTTPHeaderField: .xMSDate)
		request.addValue(token, forHTTPHeaderField: .authorization)
		
		if method == .post || method == .put {
			// For POST on query operations, it must be application/query+json
			// For attachments, must be set to the Mime type of the attachment.
			// For all other tasks, must be application/json.
			request.addValue("application/json", forHTTPHeaderField: .contentType)
		}
		
		return request
	}
}
