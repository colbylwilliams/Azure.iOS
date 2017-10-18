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
//		let configuration = URLSessionConfiguration.default
//		configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
		
//		return SessionManager(configuration: configuration)
		return SessionManager()
	}()
	
	init() {
		
	}
	
	let apiVersion = "2017-02-22"
	
	var resourceName: String!
	var tokenProvider: ADTokenProvider!
	
	public func setup (_ name: String, key: String, keyType: ADTokenType) {
		resourceName = name
		tokenProvider = ADTokenProvider(key: key, keyType: keyType, tokenVersion: "1.0")
	}
	
	
	public func database (_ databaseId: String, callback: @escaping (ADDatabase?) -> ()) {
		
		let (url, link) = ADResourceUri(resourceName).database(databaseId)
		
		let (token, date) = tokenProvider.getToken(verb: .get, resourceType: .database, resourceLink: link)
		
		var request = URLRequest(url: url)
		
		request.method = .get
		
		request.addValue(date, forHTTPHeaderField: .xMSDate)
		request.addValue(token, forHTTPHeaderField: .authorization)
		request.addValue(apiVersion, forHTTPHeaderField: .xMSVersion)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
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

		let (url, link) = ADResourceUri(resourceName).collection(databaseId, collectionId: collectionId)
		
		let (token, date) = tokenProvider.getToken(verb: .get, resourceType: .collection, resourceLink: link)
		
		var request = URLRequest(url: url)
		
		request.method = .get
		
		request.addValue(date, forHTTPHeaderField: .xMSDate)
		request.addValue(token, forHTTPHeaderField: .authorization)
		request.addValue(apiVersion, forHTTPHeaderField: .xMSVersion)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
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
		
		let (url, link) = ADResourceUri(resourceName).document(databaseId, collectionId: collectionId, documentId: documentId)
		
		let (token, date) = tokenProvider.getToken(verb: .get, resourceType: .document, resourceLink: link)
		
		var request = URLRequest(url: url)
		
		request.method = .get
		
		request.addValue(date, forHTTPHeaderField: .xMSDate)
		request.addValue(token, forHTTPHeaderField: .authorization)
		request.addValue(apiVersion, forHTTPHeaderField: .xMSVersion)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
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
