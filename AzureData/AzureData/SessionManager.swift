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
	
	//init() {}
	
	public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default/*, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil*/)
	{
		//self.delegate = delegate
		self.session = URLSession.init(configuration: configuration)
		//self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
		
		//commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
	}
	
	
	var resourceName: String!
	var tokenProvider: ADTokenProvider!
	
	public func setup (_ name: String, key: String, keyType: ADTokenType) {
		resourceName = name
		tokenProvider = ADTokenProvider(key: key, keyType: keyType, tokenVersion: "1.0")
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
	
	
	public func database (_ databaseId: String, callback: @escaping (ADDatabase?) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).database(databaseId)
		
		let request = dataRequest(.get, resourceUri: resourceUri, resourceType: .database)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				// print(json)
				DispatchQueue.main.async { callback(ADDatabase(fromJson: json)) }
			} else {
				DispatchQueue.main.async { callback(nil) }
			}
		}.resume()
	}

	public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADDocumentCollection?) -> ()) {

		let resourceUri = ADResourceUri(resourceName).collection(databaseId, collectionId: collectionId)
		
		let request = dataRequest(.get, resourceUri: resourceUri, resourceType: .collection)

		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				// print(json)
				DispatchQueue.main.async { callback(ADDocumentCollection(fromJson: json)) }
			} else {
				DispatchQueue.main.async { callback(nil) }
			}
		}.resume()
	}

	public func document<T: ADDocument> (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (T?) -> ()) {

		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId, documentId: documentId)
		
		let request = dataRequest(.get, resourceUri: resourceUri, resourceType: .document)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				// print(json)
				DispatchQueue.main.async { callback(T(fromJson: json)) }
			} else {
				DispatchQueue.main.async { callback(nil) }
			}
		}.resume()
	}
	
	public func document<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (T?) -> ()) {
		
		let resourceUri = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId)
		
		var request = dataRequest(.post, resourceUri: resourceUri, resourceType: .document)
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: document.dictionary, options: []) else {
			print("Error: Could not serialize document to JSON")
			callback(nil)
			return
		}
		
		print(httpBody)
		
		request.httpBody = httpBody
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				print(error.localizedDescription)
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				// print(json)
				DispatchQueue.main.async { callback(T(fromJson: json)) }
			} else {
				DispatchQueue.main.async { callback(nil) }
			}
		}.resume()
	}

}
