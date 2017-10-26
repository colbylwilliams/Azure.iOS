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
	
	let setupError = ADError("AzureData is not setup.  Must call AzureData.setup() before attempting CRUD operations on resources.")
	
	public var setup: Bool { return baseUri != nil }
	
	public var verboseLogging = false
	
	var baseUri: ADResourceUri?
	
	var tokenProvider: ADTokenProvider!
	
    public func setup (_ name: String, key: String, keyType: ADTokenType, verboseLogging verbose: Bool = false) {
		baseUri = ADResourceUri(name)
		tokenProvider = ADTokenProvider(key: key, keyType: keyType, tokenVersion: "1.0")
        verboseLogging = verbose
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

	
//	public func delete (_ resourceType: ADResourceType, resourceId: String, parentId: String? = nil, grandparentId: String? = nil, greatgrandparentId: String? = nil, callback: @escaping (Bool) -> ()) {
//
//		let uri = ADResourceUri(resourceName)
//
//		var resourceUri: (URL, String)?
//
//		switch resourceType {
//		case .database: 		resourceUri = uri.database(resourceId)
//		case .user: 			resourceUri = uri.user(parentId!, userId: resourceId)
//		case .permission: 		resourceUri = uri.permission(grandparentId!, userId: parentId!, permissionId: resourceId)
//		case .collection: 		resourceUri = uri.collection(parentId!, collectionId: resourceId)
//		case .storedProcedure: 	resourceUri = uri.storedProcedure(grandparentId!, collectionId: parentId!, storedProcedureId: resourceId)
//		case .trigger: 			resourceUri = uri.trigger(grandparentId!, collectionId: parentId!, triggerId: resourceId)
//		case .udf: 				resourceUri = uri.udf(grandparentId!, collectionId: parentId!, udfId: resourceId)
//		case .document: 		resourceUri = uri.document(inDatabase: grandparentId!, inCollection: parentId!, withId: resourceId)
//		case .attachment: 		resourceUri = uri.attachment(greatgrandparentId!, collectionId: grandparentId!, documentId: parentId!, attachmentId: resourceId)
//		case .offer: 			resourceUri = uri.offer(resourceId)
//		}
//
//		if let resourceUri = resourceUri {
//			return delete(resourceUri: resourceUri, resourceType: resourceType, callback: callback)
//		} else {
//			DispatchQueue.main.async { callback(false) }
//		}
//	}

	
	
	// MARK: - Databases

	// create
	public func create (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
		
		let resourceUri = baseUri?.database()
		
		let body = ["id":databaseId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .database, httpBody: httpBody, callback: callback)
	}

	// list
	public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
		
		let resourceUri = baseUri?.database()
		
		return resources(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// get
	public func get (databaseWithId databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
		
		let resourceUri = baseUri?.database(databaseId)
		
		return resource(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// delete
	public func delete (_ database: ADDatabase, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.database(database.id)
		
		return delete(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}
	
	
	
	
	// MARK: - Collections
	
	// create
	public func create (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
		
		let resourceUri = baseUri?.collection(databaseId)
		
		let body = ["id":collectionId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .collection, httpBody: httpBody, callback: callback)
	}

	// list
	public func get (collectionsIn databaseId: String, callback: @escaping (ADListResponse<ADCollection>) -> ()) {
		
		let resourceUri = baseUri?.collection(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// get
	public func get (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADCollection>) -> ()) {
		
		let resourceUri = baseUri?.collection(databaseId, collectionId: collectionId)
		
		return resource(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// delete
	public func delete (_ collection: ADCollection, fromDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.collection(databaseId, collectionId: collection.id)
		
		return delete(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// replace
	
	
	
	
	// MARK: - Documents
	
	// create
	public func create<T: ADDocument> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
		
		let body = document.dictionary
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
	}

	public func create<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        let body = document.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

	// list
	public func get<T: ADDocument> (documentsAs documentType:T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<T>) -> ()) {
		
		let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

	public func get<T: ADDocument> (documentsAs documentType:T.Type, in collection: ADCollection, callback: @escaping (ADListResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        return resources(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

	// get
	public func get<T: ADDocument> (documentWithId documentId: String, as documentType:T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: documentId)
        
        return resource(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

	public func get<T: ADDocument> (documentWithId resourceId: String, as documentType:T.Type, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: resourceId)
        
        return resource(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

	// delete
	public func delete (_ document: ADDocument, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: document.id)
		
		return delete(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

	public func delete (_ document: ADDocument, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: document.resourceId)
        
        return delete(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

    
	// replace
	public func replace<T: ADDocument> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: document.id)
		
		let body = document.dictionary
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
	}

	public func replace<T: ADDocument> (_ document: T, in collection: ADCollection, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: document.resourceId)
        
        let body = document.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

    
	// query
    public func query (documentsIn collectionId: String, inDatabase databaseId: String, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {

        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
        
        query.printQuery()
        
        let body = query.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADListResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        print(String(data: httpBody, encoding: .utf8)!)

        return self.query(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

	public func query (documentsIn collection: ADCollection, with query: ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        query.printQuery()
        
        let body = query.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADListResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        print(String(data: httpBody, encoding: .utf8)!)
        
        return self.query(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

	
	
    
	// MARK: - Attachments
	
	// create
	public func create(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        let body = ADAttachment.jsonDict(attachmentId, contentType: contentType, media: mediaUrl)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }

        return create(resourceUri: resourceUri, resourceType: .attachment, httpBody: httpBody, callback: callback)
    }

	public func create(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        let headers: [String:ADHttpRequestHeader] = [
            contentType:.contentType,
            mediaName:.slug
        ]
        
        return create(resourceUri: resourceUri, resourceType: .attachment, httpBody: media, additionalHeaders: headers, callback: callback)
    }

	// list
	public func get (attachmentsOn documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
		
		let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
		
		return resources(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// delete
	public func delete (_ attachment: ADAttachment, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachment.id)
		
		return delete(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// replace
	public func replace(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        let body = ADAttachment.jsonDict(attachmentId, contentType: contentType, media: mediaUrl)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .attachment, httpBody: httpBody, callback: callback)
    }
    
    public func replace(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        let headers: [String:ADHttpRequestHeader] = [
            contentType:.contentType,
            mediaName:.slug
        ]
        
        return replace(resourceUri: resourceUri, resourceType: .attachment, httpBody: media, additionalHeaders: headers, callback: callback)
    }

	
	
	
	// MARK: - Stored Procedures
	
	// create
	public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId)
		
		let body = ["id":storedProcedureId, "body":procedure]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}

		return create(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

	public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: ADCollection, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!)
        
        let body = ["id":storedProcedureId, "body":procedure]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
    }

	// list
	public func get (storedProceduresIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

	public func get (storedProceduresIn collection: ADCollection, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!)
        
        return resources(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
    }

	// delete
	public func delete (_ storedProcedure: ADStoredProcedure, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedure.id)
		
		return delete(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

    public func delete (_ storedProcedure: ADStoredProcedure, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedure.id)
        
        return delete(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
    }

	// replace
	public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
		
		let body = ["id":storedProcedureId, "body":procedure]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

	public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: ADCollection, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedureId)
        
        let body = ["id":storedProcedureId, "body":procedure]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
    }

	// execute
	public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Data?) -> ()) {
		
		let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
		
		let body = parameters ?? []
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			//DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			DispatchQueue.main.async { callback(nil) }
			return
		}
		
		return execute(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

	public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, in collection: ADCollection, callback: @escaping (Data?) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedureId)
        
        let body = parameters ?? []
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            //DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            DispatchQueue.main.async { callback(nil) }
            return
        }
        
        return execute(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
    }

	
	
	
	// MARK: - User Defined Functions
	
	// create
	public func create (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId)
		
		let body = ["id":functionId, "body":function]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
	}

    public func create (userDefinedFunctionWithId functionId: String, andBody function: String, in collection: ADCollection, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: functionId)
        
        let body = ["id":functionId, "body":function]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
    }

	// list
	public func get (userDefinedFunctionsIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

    public func get (userDefinedFunctionsIn collection: ADCollection, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!)
        
        return resources(resourceUri: resourceUri, resourceType: .udf, callback: callback)
    }

	// delete
	public func delete (_ userDefinedFunction: ADUserDefinedFunction, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId, udfId: userDefinedFunction.id)
		
		return delete(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

    public func delete (_ userDefinedFunction: ADUserDefinedFunction, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: userDefinedFunction.id)
        
        return delete(resourceUri: resourceUri, resourceType: .udf, callback: callback)
    }

	// replace
	public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId, udfId: functionId)
		
		let body = ["id":functionId, "body":function]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
	}

    public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, from collection: ADCollection, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: functionId)
        
        let body = ["id":functionId, "body":function]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
    }

	
	
	
	// MARK: - Triggers
	
	// create
	public func create (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
		return createTrigger(resourceUri: baseUri?.trigger(databaseId, collectionId: collectionId), triggerId: triggerId, body: triggerBody, operation: operation, type: triggerType, callback: callback)
	}

    public func create (triggerWithId triggerId: String, operation: ADTriggerOperation, type: ADTriggerType, andBody triggerBody: String, in collection: ADCollection, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return createTrigger(resourceUri: baseUri?.trigger(atLink: collection.selfLink!, withResourceId: triggerId), triggerId: triggerId, body: triggerBody, operation: operation, type: type, callback: callback)
    }
    
    fileprivate func createTrigger (resourceUri: (URL, String)?, triggerId: String, body triggerBody: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        
        let body = ADTrigger.jsonDict(triggerId, body: triggerBody, operation: operation, type: triggerType)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .trigger, httpBody: httpBody, callback: callback)
    }

	// list
	public func get (triggersIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
		
		let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

    public func get (triggersIn collection: ADCollection, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!)
        
        return resources(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
    }

	// delete
	public func delete (_ trigger: ADTrigger, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId, triggerId: trigger.id)
		
		return delete(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

    public func delete (_ trigger: ADTrigger, from collection: ADCollection, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!, withResourceId: trigger.id)
        
        return delete(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
    }

	// replace
	public func replace (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
		return replace(resourceUri: baseUri?.trigger(databaseId, collectionId: collectionId, triggerId: triggerId), triggerId: triggerId, body: triggerBody, operation: operation, type: triggerType, callback: callback)
	}

    public func replace (triggerWithId triggerId: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, andBody triggerBody: String, in collection: ADCollection, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return replace(resourceUri: baseUri?.trigger(atLink: collection.selfLink!, withResourceId: triggerId), triggerId: triggerId, body: triggerBody, operation: operation, type: triggerType, callback: callback)
    }
    
    fileprivate func replace (resourceUri: (URL, String)?, triggerId: String, body triggerBody: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        
        let body = ADTrigger.jsonDict(triggerId, body: triggerBody, operation: operation, type: triggerType)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .trigger, httpBody: httpBody, callback: callback)
    }
	
	

	
	// MARK: - Users
	
	// create
	public func create (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri?.user(databaseId)
		
		let body = ["id":userId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .user, httpBody: httpBody, callback: callback)
	}

	// list
	public func get (usersIn databaseId: String, callback: @escaping (ADListResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri?.user(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// get
	public func get (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri?.user(databaseId, userId: userId)
		
		return resource(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// delete
	public func delete (_ user: ADUser, fromDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.user(databaseId, userId: user.id)
		
		return delete(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// replace
	public func replace (userWithId userId: String, with newUserId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri?.user(databaseId, userId: userId)
		
		let body = ["id":newUserId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .user, httpBody: httpBody, callback: callback)
	}

	
	

	
	// MARK: - Permissions
	
	// create
	public func create (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri?.permission(databaseId, userId: userId)

		let body = ["id":permissionId, "permissionMode": permissionMode.rawValue, "resource":resource.selfLink!]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .permission, httpBody: httpBody, callback: callback)
	}
	
	// list
	public func get (permissionsFor userId: String, inDatabase databaseId: String, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri?.permission(databaseId, userId: userId)
		
		return resources(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// get
	public func get (permissionWithId permissionId: String, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permissionId)
		
		return resource(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// delete
	public func delete (_ permission: ADPermission, forUser userId: String, inDatabase databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permission.id)
		
		return delete(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// replace
	public func replace (permissionWithId permissionId: String, mode permissionMode: ADPermissionMode, in resource: ADResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permissionId)
		
		let body: [String : Any] = ["id":permissionId, "permissionMode": permissionMode.rawValue, "resource": resource]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .permission, httpBody: httpBody, callback: callback)
	}

	
	
	

	// MARK: - Offers
	
	// list
	public func offers (callback: @escaping (ADListResponse<ADOffer>) -> ()) {
		
		let resourceUri = baseUri?.offer()
		
		return resources(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// get
	public func get (offerWithId offerId: String, callback: @escaping (ADResponse<ADOffer>) -> ()) {
		
		let resourceUri = baseUri?.offer(offerId)
		
		return resource(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// replace
	
	// query
	

	

	// MARK: - Resources
	
	// create
	fileprivate func create<T> (resourceUri: (URL, String)?, resourceType: ADResourceType, httpBody: Data, additionalHeaders: [String:ADHttpRequestHeader]? = nil, callback: @escaping (ADResponse<T>) -> ()) {
		
		if !setup { callback(ADResponse<T>(setupError)); return }
		
		var request = dataRequest(.post, resourceUri: resourceUri!, resourceType: resourceType, additionalHeaders: additionalHeaders)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}
	
	// list
	fileprivate func resources<T> (resourceUri: (URL, String)?, resourceType: ADResourceType, callback: @escaping (ADListResponse<T>) -> ()) {

		if !setup { callback(ADListResponse<T>(setupError)); return }
		
		let request = dataRequest(.get, resourceUri: resourceUri!, resourceType: resourceType)
		
		return sendRequest(request, resourceType: resourceType, callback: callback)
	}
	
	// get
	fileprivate func resource<T>(resourceUri: (URL, String)?, resourceType: ADResourceType, callback: @escaping (ADResponse<T>) -> ()) {
		
		if !setup { callback(ADResponse<T>(setupError)); return }
		
		let request = dataRequest(.get, resourceUri: resourceUri!, resourceType: resourceType)
		
		return sendRequest(request, callback: callback)
	}

	// delete
	fileprivate func delete(resourceUri: (URL, String)?, resourceType: ADResourceType, callback: @escaping (Bool) -> ()) {
		
		if !setup { callback(false); return }
		
		let request = dataRequest(.delete, resourceUri: resourceUri!, resourceType: resourceType)
		
		return sendRequest(request, callback: callback)
	}
	
	// replace
	fileprivate func replace<T> (resourceUri: (URL, String)?, resourceType: ADResourceType, httpBody: Data, additionalHeaders: [String:ADHttpRequestHeader]? = nil, callback: @escaping (ADResponse<T>) -> ()) {
		
		if !setup { callback(ADResponse<T>(setupError)); return }
		
		var request = dataRequest(.put, resourceUri: resourceUri!, resourceType: resourceType, additionalHeaders: additionalHeaders)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}

    // query
    fileprivate func query<T> (resourceUri: (URL, String)?, resourceType: ADResourceType, httpBody: Data, callback: @escaping (ADListResponse<T>) -> ()) {
		
		if !setup { callback(ADListResponse<T>(setupError)); return }
		
        var request = dataRequest(.post, resourceUri: resourceUri!, resourceType: resourceType, forQuery: true)
        
        request.httpBody = httpBody
        
        return sendRequest(request, resourceType: resourceType, callback: callback)
    }

	// execute
	fileprivate func execute (resourceUri: (URL, String)?, resourceType: ADResourceType, httpBody: Data, callback: @escaping (Data?) -> ()) {
		
		if !setup { callback(nil); return }
		
		var request = dataRequest(.post, resourceUri: resourceUri!, resourceType: resourceType)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}

	
	
	
	// MARK: - Request
	
	fileprivate func sendRequest<T> (_ request: URLRequest, callback: @escaping (ADResponse<T>) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				if self.verboseLogging { print(error.localizedDescription) }
				DispatchQueue.main.async { callback(ADResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error:error)))) }
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				if self.verboseLogging { print(json) }
				
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

	
	fileprivate func sendRequest<T> (_ request: URLRequest, resourceType: ADResourceType, callback: @escaping (ADListResponse<T>) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				if self.verboseLogging { print(error.localizedDescription) }
				DispatchQueue.main.async { callback(ADListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error:error)))) }
			}
			if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let json = jsonData  {
				if self.verboseLogging { print(json) }
				
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


	fileprivate func sendRequest (_ request:URLRequest, callback: @escaping (Data?) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				if self.verboseLogging { print(error.localizedDescription) }
				DispatchQueue.main.async { callback(nil) }
			} else {
				DispatchQueue.main.async { callback(data) }
			}
		}.resume()
	}

	
	fileprivate func sendRequest (_ request:URLRequest, callback: @escaping (Bool) -> ()) {
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		session.dataTask(with: request) { (data, response, error) in
			
			DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
			
			if let error = error {
				if self.verboseLogging { print(error.localizedDescription) }
				DispatchQueue.main.async { callback(false) }
			} else {
				DispatchQueue.main.async { callback(true) }
			}
		}.resume()
	}

	
    fileprivate func dataRequest(_ method: ADHttpMethod, resourceUri: (url:URL, link:String), resourceType: ADResourceType, additionalHeaders:[String:ADHttpRequestHeader]? = nil, forQuery: Bool = false) -> URLRequest {
		
		let (token, date) = tokenProvider.getToken(verb: method, resourceType: resourceType, resourceLink: resourceUri.link)
		
		var request = URLRequest(url: resourceUri.url)
		
		request.method = method
		
		request.addValue(date, forHTTPHeaderField: .xMSDate)
		request.addValue(token, forHTTPHeaderField: .authorization)
		
        if forQuery {
        
            request.addValue ("true", forHTTPHeaderField: .xMSDocumentdbIsQuery)
            request.addValue("application/query+json", forHTTPHeaderField: .contentType)
        
        } else if (method == .post || method == .put) && resourceType != .attachment {
			// For POST on query operations, it must be application/query+json
			// For attachments, must be set to the Mime type of the attachment.
			// For all other tasks, must be application/json.
			request.addValue("application/json", forHTTPHeaderField: .contentType)
		}
		
        if let additionalHeaders = additionalHeaders {
            for header in additionalHeaders {
                request.addValue(header.key, forHTTPHeaderField: header.value)
            }
        }
        
		return request
	}
}
