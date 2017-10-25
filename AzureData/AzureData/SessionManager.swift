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
	
	public var verboseLogging = false
	
	var baseUri: ADResourceUri!
	
	var resourceName: String! {
		willSet {
			baseUri = ADResourceUri(newValue)
		}
	}
	
	var tokenProvider: ADTokenProvider!
	
    public func setup (_ name: String, key: String, keyType: ADTokenType, verboseLogging: Bool = false) {
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
		case .document: 		resourceUri = uri.document(inDatabase: grandparentId!, inCollection: parentId!, withId: resourceId)
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
		
		let resourceUri = baseUri.database()
		
		let body = ["id":databaseId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .database, httpBody: httpBody, callback: callback)
	}

	// list
	public func databases (callback: @escaping (ADListResponse<ADDatabase>) -> ()) {
		
		let resourceUri = baseUri.database()
		
		return resources(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// get
	public func database (_ databaseId: String, callback: @escaping (ADResponse<ADDatabase>) -> ()) {
		
		let resourceUri = baseUri.database(databaseId)
		
		return resource(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}

	// delete
	public func delete (_ resource: ADDatabase, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.database(resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .database, callback: callback)
	}
	
	
	
	// MARK: - DocumentCollections
	
	// create
	public func createDocumentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = baseUri.collection(databaseId)
		
		let body = ["id":collectionId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .collection, httpBody: httpBody, callback: callback)
	}

	// list
	public func documentCollections (_ databaseId: String, callback: @escaping (ADListResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = baseUri.collection(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// get
	public func documentCollection (_ databaseId: String, collectionId: String, callback: @escaping (ADResponse<ADDocumentCollection>) -> ()) {
		
		let resourceUri = baseUri.collection(databaseId, collectionId: collectionId)
		
		return resource(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// delete
	public func delete (_ resource: ADDocumentCollection, databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.collection(databaseId, collectionId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .collection, callback: callback)
	}

	// replace
	
	
	
	
	// MARK: - Documents
	
	// create
	public func createDocument<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId)
		
		let body = document.dictionary
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: (resourceUri.0, collectionId.lowercased()), resourceType: .document, httpBody: httpBody, callback: callback)
	}

    public func createDocument<T: ADDocument> (_ document: T, atSelfLink selfLink: String, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink)
        
        let body = document.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

	// list
	public func documents<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, callback: @escaping (ADListResponse<T>) -> ()) {
		
		let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

    public func documents<T: ADDocument> (atSelfLink selfLink: String, as documentType:T.Type, callback: @escaping (ADListResponse<T>) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink)
        
        return resources(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

	// get
    public func document<T: ADDocument> (_ documentType:T.Type, databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId, withId: documentId)
        
        return resource(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

    public func document<T: ADDocument> (withResourceId resourceId: String, atSelfLink selfLink: String, as documentType:T.Type, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink, withResourceId: resourceId)
        
        return resource(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

	// delete
	public func delete (_ resource: ADDocument, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId, withId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .document, callback: callback)
	}

    public func delete (_ resource: ADDocument, atSelfLink selfLink:String, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink, withResourceId: resource.resourceId)
        
        return delete(resourceUri: resourceUri, resourceType: .document, callback: callback)
    }

    
	// replace
	public func replace<T: ADDocument> (_ databaseId: String, collectionId: String, document: T, callback: @escaping (ADResponse<T>) -> ()) {
		
		let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId, withId: document.id)
		
		let body = document.dictionary
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
	}

    public func replace<T: ADDocument> (_ resource: T, atSelfLink selfLink: String, callback: @escaping (ADResponse<T>) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink, withResourceId: resource.resourceId)
        
        let body = resource.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

    
	// query
    public func query (_ databaseId: String, collectionId: String, query:ADQuery, callback: @escaping (ADListResponse<ADDocument>) -> ()) {

        let resourceUri = baseUri.document(inDatabase: databaseId, inCollection: collectionId)
        
        query.printQuery()
        
        let body = query.dictionary
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADListResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        print(String(data: httpBody, encoding: .utf8)!)

        return self.query(resourceUri: resourceUri, resourceType: .document, httpBody: httpBody, callback: callback)
    }

    public func query (_ query: ADQuery, atSelfLink selfLink: String, callback: @escaping (ADListResponse<ADDocument>) -> ()) {
        
        let resourceUri = baseUri.document(atLink: selfLink)
        
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
    public func createAttachment(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaUrl: URL, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        let body = ADAttachment.jsonDict(attachmentId, contentType: contentType, media: mediaUrl)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }

        return create(resourceUri: resourceUri, resourceType: .attachment, httpBody: httpBody, callback: callback)
    }

    public func createAttachment(_ databaseId: String, collectionId: String, documentId: String, contentType: String, mediaName: String, media:Data, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        let headers: [String:ADHttpRequestHeader] = [
            contentType:.contentType,
            mediaName:.slug
        ]
        
        return create(resourceUri: resourceUri, resourceType: .attachment, httpBody: media, additionalHeaders: headers, callback: callback)
    }

	// list
	public func attachments (_ databaseId: String, collectionId: String, documentId: String, callback: @escaping (ADListResponse<ADAttachment>) -> ()) {
		
		let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId)
		
		return resources(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// delete
	public func delete (_ resource: ADAttachment, databaseId: String, collectionId: String, documentId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .attachment, callback: callback)
	}

	// replace
    public func replace(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaUrl: URL, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        let body = ADAttachment.jsonDict(attachmentId, contentType: contentType, media: mediaUrl)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .attachment, httpBody: httpBody, callback: callback)
    }
    
    public func replace(_ databaseId: String, collectionId: String, documentId: String, attachmentId: String, contentType: String, mediaName: String, media:Data, callback: @escaping (ADResponse<ADAttachment>) -> ()) {
        
        let resourceUri = baseUri.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        let headers: [String:ADHttpRequestHeader] = [
            contentType:.contentType,
            mediaName:.slug
        ]
        
        return replace(resourceUri: resourceUri, resourceType: .attachment, httpBody: media, additionalHeaders: headers, callback: callback)
    }

	
	
	
	// MARK: - Stored Procedures
	
	// create
	public func createStoredProcedure (_ databaseId: String, collectionId: String, storedProcedureId: String, body procedure: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri.storedProcedure(databaseId, collectionId: collectionId)
		
		let body = ["id":storedProcedureId, "body":procedure]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}

		return create(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

    public func createStoredProcedure (withId storedProcedureId: String, andBody procedure: String, atSelfLink selfLink: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri.storedProcedure(atLink: selfLink)
        
        let body = ["id":storedProcedureId, "body":procedure]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
    }

	// list
	public func storedProcedures (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri.storedProcedure(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

    public func storedProcedures (atSelfLink selfLink: String, callback: @escaping (ADListResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri.storedProcedure(atLink: selfLink)
        
        return resources(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
    }

	// delete
	public func delete (_ resource: ADStoredProcedure, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
	}

    public func delete (_ resource: ADStoredProcedure, atSelfLink selfLink:String, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri.storedProcedure(atLink: selfLink, withResourceId: resource.id)
        
        return delete(resourceUri: resourceUri, resourceType: .storedProcedure, callback: callback)
    }

	// replace
	public func replace (_ databaseId: String, collectionId: String, storedProcedureId: String, body procedure: String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
		
		let resourceUri = baseUri.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
		
		let body = ["id":storedProcedureId, "body":procedure]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

    public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, atSelfLink selfLink:String, callback: @escaping (ADResponse<ADStoredProcedure>) -> ()) {
        
        let resourceUri = baseUri.storedProcedure(atLink: selfLink, withResourceId: storedProcedureId)
        
        let body = ["id":storedProcedureId, "body":procedure]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
    }

	// execute
	public func execute (_ databaseId: String, collectionId: String, storedProcedureId: String, parameters: [String]?, callback: @escaping (Data?) -> ()) {
		
		let resourceUri = baseUri.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
		
		let body = parameters ?? []
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			//DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			DispatchQueue.main.async { callback(nil) }
			return
		}
		
		return execute(resourceUri: resourceUri, resourceType: .storedProcedure, httpBody: httpBody, callback: callback)
	}

    public func execute (storedProcedureWithId storedProcedureId: String, atSelfLink selfLink:String, usingParameters parameters: [String]?, callback: @escaping (Data?) -> ()) {
        
        let resourceUri = baseUri.storedProcedure(atLink: selfLink, withResourceId: storedProcedureId)
        
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
	public func createUserDefinedFunction (_ databaseId: String, collectionId: String, functionId: String, body function: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri.udf(databaseId, collectionId: collectionId)
		
		let body = ["id":functionId, "body":function]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
	}

    public func createUserDefinedFunction (withId functionId: String, andBody function: String, atSelfLink selfLink: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri.udf(atLink: selfLink, withResourceId: functionId)
        
        let body = ["id":functionId, "body":function]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
    }

	// list
	public func userDefinedFunctions (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri.udf(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

    public func userDefinedFunctions (atSelfLink selfLink:String, callback: @escaping (ADListResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri.udf(atLink: selfLink)
        
        return resources(resourceUri: resourceUri, resourceType: .udf, callback: callback)
    }

	// delete
	public func delete (_ resource: ADUserDefinedFunction, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.udf(databaseId, collectionId: collectionId, udfId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .udf, callback: callback)
	}

    public func delete (_ resource: ADUserDefinedFunction, atSelfLink selfLink:String, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri.udf(atLink: selfLink, withResourceId: resource.id)
        
        return delete(resourceUri: resourceUri, resourceType: .udf, callback: callback)
    }

	// replace
	public func replace (_ databaseId: String, collectionId: String, functionId: String, body function: String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
		
		let resourceUri = baseUri.udf(databaseId, collectionId: collectionId, udfId: functionId)
		
		let body = ["id":functionId, "body":function]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
	}

    public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, atSelfLink selfLink:String, callback: @escaping (ADResponse<ADUserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri.udf(atLink: selfLink, withResourceId: functionId)
        
        let body = ["id":functionId, "body":function]
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .udf, httpBody: httpBody, callback: callback)
    }

	
	
	
	// MARK: - Triggers
	
	// create
	public func createTrigger (_ databaseId: String, collectionId: String, triggerId: String, triggerBody: String, operation: ADTriggerOperation, triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
		return createTrigger(resourceUri: baseUri.trigger(databaseId, collectionId: collectionId), triggerId: triggerId, body: triggerBody, operation: operation, type: triggerType, callback: callback)
	}

    public func createTrigger (withId triggerId: String, andBody body: String, operation: ADTriggerOperation, type: ADTriggerType, atSelfLink selfLink:String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return createTrigger(resourceUri: baseUri.trigger(atLink: selfLink, withResourceId: triggerId), triggerId: triggerId, body: body, operation: operation, type: type, callback: callback)
    }
    
    public func createTrigger (resourceUri: (URL, String), triggerId: String, body triggerBody: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        
        let body = ADTrigger.jsonDict(triggerId, body: triggerBody, operation: operation, type: triggerType)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return create(resourceUri: resourceUri, resourceType: .trigger, httpBody: httpBody, callback: callback)
    }

	// list
	public func triggers (_ databaseId: String, collectionId: String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
		
		let resourceUri = baseUri.trigger(databaseId, collectionId: collectionId)
		
		return resources(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

    public func triggers (atSelfLink selfLink:String, callback: @escaping (ADListResponse<ADTrigger>) -> ()) {
        
        let resourceUri = baseUri.trigger(atLink: selfLink)
        
        return resources(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
    }

	// delete
	public func delete (_ resource: ADTrigger, databaseId: String, collectionId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.trigger(databaseId, collectionId: collectionId, triggerId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
	}

    public func delete (_ resource: ADTrigger, atSelfLink selfLink:String, callback: @escaping (Bool) -> ()) {
        
        let resourceUri = baseUri.trigger(atLink: selfLink, withResourceId: resource.id)
        
        return delete(resourceUri: resourceUri, resourceType: .trigger, callback: callback)
    }

	// replace
	public func replace (_ databaseId: String, collectionId: String, triggerId: String, triggerBody body: String, operation: ADTriggerOperation, triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
		return replace(resourceUri: baseUri.trigger(databaseId, collectionId: collectionId, triggerId: triggerId), triggerId: triggerId, body: body, operation: operation, type: triggerType, callback: callback)
	}

    public func replace (triggerWithId triggerId: String, andBody body: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, atSelfLink selfLink: String, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        return replace(resourceUri: baseUri.trigger(atLink: selfLink, withResourceId: triggerId), triggerId: triggerId, body: body, operation: operation, type: triggerType, callback: callback)
    }
    
    public func replace (resourceUri: (URL, String), triggerId: String, body triggerBody: String, operation: ADTriggerOperation, type triggerType: ADTriggerType, callback: @escaping (ADResponse<ADTrigger>) -> ()) {
        
        let body = ADTrigger.jsonDict(triggerId, body: triggerBody, operation: operation, type: triggerType)
        
        guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
            return
        }
        
        return replace(resourceUri: resourceUri, resourceType: .trigger, httpBody: httpBody, callback: callback)
    }
	
	
	// MARK: - Users
	
	// create
	public func createUser (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri.user(databaseId)
		
		let body = ["id":userId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .user, httpBody: httpBody, callback: callback)
	}

	// list
	public func users (_ databaseId: String, callback: @escaping (ADListResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri.user(databaseId)
		
		return resources(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// get
	public func user (_ databaseId: String, userId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri.user(databaseId, userId: userId)
		
		return resource(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// delete
	public func delete (_ resource: ADUser, databaseId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.user(databaseId, userId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .user, callback: callback)
	}

	// replace
	public func replace (_ databaseId: String, userId: String, newUserId: String, callback: @escaping (ADResponse<ADUser>) -> ()) {
		
		let resourceUri = baseUri.user(databaseId, userId: userId)
		
		let body = ["id":newUserId]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .user, httpBody: httpBody, callback: callback)
	}

	
	

	
	// MARK: - Permissions
	
	// create
	public func createPermission (_ resource: ADResource, databaseId: String, userId: String, permissionId: String,  permissionMode: ADPermissionMode, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri.permission(databaseId, userId: userId)

		let body = ["id":permissionId, "permissionMode": permissionMode.rawValue, "resource":resource.selfLink!]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return create(resourceUri: resourceUri, resourceType: .permission, httpBody: httpBody, callback: callback)
	}
	
	// list
	public func permissions (_ databaseId: String, userId: String, callback: @escaping (ADListResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri.permission(databaseId, userId: userId)
		
		return resources(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// get
	public func permission (_ databaseId: String, userId: String, permissionId: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri.permission(databaseId, userId: userId, permissionId: permissionId)
		
		return resource(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// delete
	public func delete (_ resource: ADPermission, databaseId: String, userId: String, callback: @escaping (Bool) -> ()) {
		
		let resourceUri = baseUri.permission(databaseId, userId: userId, permissionId: resource.id)
		
		return delete(resourceUri: resourceUri, resourceType: .permission, callback: callback)
	}

	// replace
	public func replace (_ databaseId: String, userId: String, permissionId: String,  permissionMode: ADPermissionMode, resource: String, callback: @escaping (ADResponse<ADPermission>) -> ()) {
		
		let resourceUri = baseUri.permission(databaseId, userId: userId, permissionId: permissionId)
		
		let body = ["id":permissionId, "permissionMode": permissionMode.rawValue, "resource":resource]
		
		guard JSONSerialization.isValidJSONObject(body), let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			DispatchQueue.main.async { callback(ADResponse(ADError("Error: Could not serialize document to JSON"))) }
			return
		}
		
		return replace(resourceUri: resourceUri, resourceType: .permission, httpBody: httpBody, callback: callback)
	}

	
	
	
	// MARK: - Offers
	
	// list
	public func offers (callback: @escaping (ADListResponse<ADOffer>) -> ()) {
		
		let resourceUri = baseUri.offer()
		
		return resources(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// get
	public func offer (_ offerId: String, callback: @escaping (ADResponse<ADOffer>) -> ()) {
		
		let resourceUri = baseUri.offer(offerId)
		
		return resource(resourceUri: resourceUri, resourceType: .offer, callback: callback)
	}

	// replace
	
	// query
	

	

	// MARK: - Resources
	
	// create
	fileprivate func create<T> (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, additionalHeaders: [String:ADHttpRequestHeader]? = nil, callback: @escaping (ADResponse<T>) -> ()) {
		
		var request = dataRequest(.post, resourceUri: resourceUri, resourceType: resourceType, additionalHeaders: additionalHeaders)
		
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
	fileprivate func replace<T> (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, additionalHeaders: [String:ADHttpRequestHeader]? = nil, callback: @escaping (ADResponse<T>) -> ()) {
		
		var request = dataRequest(.put, resourceUri: resourceUri, resourceType: resourceType, additionalHeaders: additionalHeaders)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}

    // query
    fileprivate func query<T> (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, callback: @escaping (ADListResponse<T>) -> ()) {
        
        var request = dataRequest(.post, resourceUri: resourceUri, resourceType: resourceType, forQuery: true)
        
        request.httpBody = httpBody
        
        return sendRequest(request, resourceType: resourceType, callback: callback)
    }

	// execute
	fileprivate func execute (resourceUri: (URL, String), resourceType: ADResourceType, httpBody: Data, callback: @escaping (Data?) -> ()) {
		
		var request = dataRequest(.post, resourceUri: resourceUri, resourceType: resourceType)
		
		request.httpBody = httpBody
		
		return sendRequest(request, callback: callback)
	}

	
	
	
	// MARK: - Request
	
	fileprivate func sendRequest<T> (_ request:URLRequest, callback: @escaping (ADResponse<T>) -> ()) {
		
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

	
	fileprivate func sendRequest<T> (_ request:URLRequest, resourceType: ADResourceType, callback: @escaping (ADListResponse<T>) -> ()) {
		
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
