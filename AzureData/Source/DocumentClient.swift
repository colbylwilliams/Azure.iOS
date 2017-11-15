//
//  DocumentClient.swift
//  AzureData iOS
//
//  Created by Colby Williams on 11/11/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public class DocumentClient {
    
    open static let `default`: DocumentClient = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = DocumentClient.defaultHTTPHeaders
        
        return DocumentClient(configuration: configuration)
        //return SessionManager()
    }()
    
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default/*, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil*/)
    {
        //self.delegate = delegate
        self.session = URLSession.init(configuration: configuration)
        //self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        
        //commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }
    
    let unknownError = ADError("A unknown error occured.")
    let setupError = ADError("AzureData is not setup.  Must call AzureData.setup() before attempting CRUD operations on resources.")
    let invalidIdError = ADError("Cosmos DB Resource IDs must not exceed 255 characters and cannot contain whitespace")
    let jsonError = ADError("Error: Could not serialize document to JSON")
    
    public var setup: Bool { return baseUri != nil }
    
    public var verboseLogging = false
    
    var baseUri: ResourceUri?
    
    var tokenProvider: TokenProvider!
    
    public func setup (_ name: String, key: String, keyType: TokenType, verboseLogging verbose: Bool = false) {
        baseUri = ResourceUri(name)
        tokenProvider = TokenProvider(key: key, keyType: keyType, tokenVersion: "1.0")
        verboseLogging = verbose
    }
    
    public func reset () {
        baseUri = nil
        tokenProvider = nil
    }
    
    public var dateDecoder: ((Decoder) throws -> Date)? = nil
    
    public var dateEncoder: ((Date, Encoder) throws -> Void)? = nil
    
    public lazy var jsonEncoder: JSONEncoder = {
        
        let encoder = JSONEncoder()
        
        if self.dateEncoder == nil { self.dateEncoder = DocumentClient.roundTripIso8601Encoder }
        
        encoder.dateEncodingStrategy = .custom(self.dateEncoder!)
        
        return encoder
    }()
    
    public lazy var jsonDecoder: JSONDecoder = {
        
        if self.dateDecoder == nil { self.dateDecoder = DocumentClient.roundTripIso8601Decoder }
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom(self.dateDecoder!)
        
        return decoder
    }()
    
    fileprivate static let roundTripIso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        return formatter
    }()
    
    public static func roundTripIso8601Encoder(date: Date, encoder: Encoder) throws -> Void {
        
        var container = encoder.singleValueContainer()
        
        if container.codingPath.last?.stringValue == "_ts" {
            try container.encode(date.timeIntervalSince1970)
        } else {
            var data = roundTripIso8601.string(from: date)
            
            if let fractionStart = data.range(of: "."),
                let fractionEnd = data.index(fractionStart.lowerBound, offsetBy: 7, limitedBy: data.endIndex) {
                let fractionRange = fractionStart.lowerBound..<fractionEnd
                let intVal = Int64(1000000 * date.timeIntervalSince1970)
                let newFraction = String(format: ".%06d", intVal % 1000000)
                data.replaceSubrange(fractionRange, with: newFraction)
            }
            
            try container.encode(data)
        }
    }
    
    public static func roundTripIso8601Decoder(decoder: Decoder) throws -> Date {
        
        let container = try decoder.singleValueContainer()
        
        if container.codingPath.last?.stringValue == "_ts" {
            let dateDouble = try container.decode(Double.self)
            return Date.init(timeIntervalSince1970: dateDouble)
        } else {
            
            let dateString = try container.decode(String.self)
        
            guard let parsedDate = roundTripIso8601.date(from: dateString) else {
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unable to parse string (\(dateString)) into date"))
            }
            
            var preliminaryDate = Date(timeIntervalSinceReferenceDate: floor(parsedDate.timeIntervalSinceReferenceDate))
            
            if let fractionStart = dateString.range(of: "."),
                let fractionEnd = dateString.index(fractionStart.lowerBound, offsetBy: 7, limitedBy: dateString.endIndex) {
                let fractionRange = fractionStart.lowerBound..<fractionEnd
                let fractionStr = String(dateString[fractionRange])
                
                if var fraction = Double(fractionStr) {
                    fraction = Double(floor(1000000*fraction)/1000000)
                    preliminaryDate.addTimeInterval(fraction)
                }
            }
            return preliminaryDate
        }
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
                let executable =    info[kCFBundleExecutableKey as String]  as? String ?? "Unknown" // iOS Example
                let bundle =        info[kCFBundleIdentifierKey as String]  as? String ?? "Unknown" // com.colbylwilliams.azuredata
                let appVersion =    info["CFBundleShortVersionString"]      as? String ?? "Unknown" // 1.1.0
                let appBuild =      info[kCFBundleVersionKey as String]     as? String ?? "Unknown" // 23
                
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
                        let adInfo = Bundle(for: DocumentClient.self).infoDictionary,
                        let build = adInfo["CFBundleShortVersionString"]
                        else { return "Unknown" }
                    
                    return "AzureData/\(build)" // AzureData/2.0.0
                }()
                
                print("\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(azureDataVersion)"); print()
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(azureDataVersion)"
            }
            
            return "AzureData"
        }()
        
        let dict: [HttpRequestHeader:String] = [
            .acceptEncoding: acceptEncoding,
            .acceptLanguage: acceptLanguage,
            .userAgent: userAgent,
            .xMSVersion: apiVersion
        ]
        
        return dict.strings
    }()
    
    
    /// The underlying session.
    open let session: URLSession
    
    
    
    // MARK: - Databases
    
    // create
    public func create (databaseWithId databaseId: String, callback: @escaping (Response<Database>) -> ()) {
        
        let resourceUri = baseUri?.database()
        
        return self.create(resourceWithId: databaseId, at: resourceUri, callback: callback)
    }
    
    // list
    public func databases (callback: @escaping (ListResponse<Database>) -> ()) {
        
        let resourceUri = baseUri?.database()
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get (databaseWithId databaseId: String, callback: @escaping (Response<Database>) -> ()) {
        
        let resourceUri = baseUri?.database(databaseId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ database: Database, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.database(database.id)
        
        return self.delete(Database.self, resourceUri: resourceUri, callback: callback)
    }
    
    
    
    
    
    // MARK: - Collections
    
    // create
    public func create (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<DocumentCollection>) -> ()) {
        
        let resourceUri = baseUri?.collection(databaseId)
        
        return self.create(resourceWithId: collectionId, at: resourceUri, callback: callback)
    }
    
    // list
    public func get (collectionsIn databaseId: String, callback: @escaping (ListResponse<DocumentCollection>) -> ()) {
        
        let resourceUri = baseUri?.collection(databaseId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get (collectionWithId collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<DocumentCollection>) -> ()) {
        
        let resourceUri = baseUri?.collection(databaseId, collectionId: collectionId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ collection: DocumentCollection, fromDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.collection(databaseId, collectionId: collection.id)
        
        return self.delete(DocumentCollection.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    
    
    
    
    
    // MARK: - Documents
    
    // create
    public func create<T: Document> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
        
        return self.create(document, at: resourceUri, callback: callback)
    }
    
    public func create<T: Document> (_ document: T, in collection: DocumentCollection, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        return self.create(document, at: resourceUri, callback: callback)
    }
    
    // list
    public func get<T: Document> (documentsAs documentType:T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get<T: Document> (documentsAs documentType:T.Type, in collection: DocumentCollection, callback: @escaping (ListResponse<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get<T: Document> (documentWithId documentId: String, as documentType:T.Type, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: documentId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    public func get<T: Document> (documentWithId resourceId: String, as documentType:T.Type, in collection: DocumentCollection, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: resourceId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ document: Document, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: document.id)
        
        return self.delete(Document.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ document: Document, from collection: DocumentCollection, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: document.resourceId)
        
        return self.delete(Document.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace<T: Document> (_ document: T, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId, withId: document.id)
        
        return self.replace(document, at: resourceUri, callback: callback)
    }
    
    public func replace<T: Document> (_ document: T, in collection: DocumentCollection, callback: @escaping (Response<T>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!, withResourceId: document.resourceId)
        
        return self.replace(document, at: resourceUri, callback: callback)
    }
    
    // query
    public func query (documentsIn collectionId: String, inDatabase databaseId: String, with query: Query, callback: @escaping (ListResponse<Document>) -> ()) {
        
        let resourceUri = baseUri?.document(inDatabase: databaseId, inCollection: collectionId)
     
        return self.query(query, at: resourceUri, callback: callback)
    }
    
    public func query (documentsIn collection: DocumentCollection, with query: Query, callback: @escaping (ListResponse<Document>) -> ()) {
        
        let resourceUri = baseUri?.document(atLink: collection.selfLink!)
        
        return self.query(query, at: resourceUri, callback: callback)
    }

    
    

    
    // MARK: - Attachments
    
    // create
    public func create(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        return self.create(Attachment(id: attachmentId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, contentType: contentType, mediaLink: mediaUrl.absoluteString), at: resourceUri, callback: callback)
    }
    
    public func create(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        return self.createOrReplace(media, at: resourceUri, additionalHeaders: [ contentType: .contentType, mediaName: .slug ], callback: callback)
    }
    
    public func create(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument document: Document, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!)
        
        return self.create(Attachment(id: attachmentId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, contentType: contentType, mediaLink: mediaUrl.absoluteString), at: resourceUri, callback: callback)
    }
    
    public func create(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument document: Document, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!)
        
        return self.createOrReplace(media, at: resourceUri, additionalHeaders: [ contentType: .contentType, mediaName: .slug ], callback: callback)
    }
    
    // list
    public func get (attachmentsOn documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (attachmentsOn document: Document, callback: @escaping (ListResponse<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ attachment: Attachment, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachment.id)
        
        return self.delete(Attachment.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ attachment: Attachment, onDocument document: Document, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!, withResourceId: attachment.id)
        
        return self.delete(Attachment.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        return self.replace(Attachment(id: attachmentId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, contentType: contentType, mediaLink: mediaUrl.absoluteString), at: resourceUri, callback: callback)
    }
    
    public func replace(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument documentId: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId)
        
        return self.createOrReplace(media, at: resourceUri, replacing: true, additionalHeaders: [ contentType: .contentType, mediaName: .slug ], callback: callback)
    }
    
    public func replace(attachmentWithId attachmentId: String, contentType: String, andMediaUrl mediaUrl: URL, onDocument document: Document, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!, withResourceId: attachmentId)
        
        return self.replace(Attachment(id: attachmentId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, contentType: contentType, mediaLink: mediaUrl.absoluteString), at: resourceUri, callback: callback)
    }
    
    public func replace(attachmentWithId attachmentId: String, contentType: String, name mediaName: String, with media: Data, onDocument document: Document, callback: @escaping (Response<Attachment>) -> ()) {
        
        let resourceUri = baseUri?.attachment(atLink: document.selfLink!, withResourceId: attachmentId)

        return self.createOrReplace(media, at: resourceUri, replacing: true, additionalHeaders: [ contentType: .contentType, mediaName: .slug ], callback: callback)
    }

    
    
    
    
    // MARK: - Stored Procedures
    
    // create
    public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId)
        
        return self.create(resourceWithId: storedProcedureId, andData: ["body":procedure], at: resourceUri, callback: callback)
    }
    
    public func create (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: DocumentCollection, callback: @escaping (Response<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!)
        
        return self.create(resourceWithId: storedProcedureId, andData: ["body":procedure], at: resourceUri, callback: callback)
    }
    
    // list
    public func get (storedProceduresIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (storedProceduresIn collection: DocumentCollection, callback: @escaping (ListResponse<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ storedProcedure: StoredProcedure, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedure.id)
        
        return self.delete(StoredProcedure.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ storedProcedure: StoredProcedure, from collection: DocumentCollection, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedure.id)
        
        return self.delete(StoredProcedure.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
        
        return self.replace(resourceWithId: storedProcedureId, andData: ["body":procedure], at: resourceUri, callback: callback)
    }
    
    public func replace (storedProcedureWithId storedProcedureId: String, andBody procedure: String, in collection: DocumentCollection, callback: @escaping (Response<StoredProcedure>) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedureId)
        
        return self.replace(resourceWithId: storedProcedureId, andData: ["body":procedure], at: resourceUri, callback: callback)
    }
    
    // execute
    public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId)
        
        return self.execute(StoredProcedure.self, withBody: parameters, resourceUri: resourceUri, callback: callback)
    }
    
    public func execute (storedProcedureWithId storedProcedureId: String, usingParameters parameters: [String]?, in collection: DocumentCollection, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.storedProcedure(atLink: collection.selfLink!, withResourceId: storedProcedureId)
        
        return self.execute(StoredProcedure.self, withBody: parameters, resourceUri: resourceUri, callback: callback)
    }

    
    

    
    // MARK: - User Defined Functions
    
    // create
    public func create (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId)
        
        return self.create(resourceWithId: functionId, andData: ["body":function], at: resourceUri, callback: callback)
    }
    
    public func create (userDefinedFunctionWithId functionId: String, andBody function: String, in collection: DocumentCollection, callback: @escaping (Response<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: functionId)
        
        return self.create(resourceWithId: functionId, andData: ["body":function], at: resourceUri, callback: callback)
    }
    
    // list
    public func get (userDefinedFunctionsIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (userDefinedFunctionsIn collection: DocumentCollection, callback: @escaping (ListResponse<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ userDefinedFunction: UserDefinedFunction, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId, udfId: userDefinedFunction.id)
        
        return self.delete(UserDefinedFunction.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ userDefinedFunction: UserDefinedFunction, from collection: DocumentCollection, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: userDefinedFunction.id)
        
        return self.delete(UserDefinedFunction.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(databaseId, collectionId: collectionId, udfId: functionId)
        
        return self.replace(resourceWithId: functionId, andData: ["body":function], at: resourceUri, callback: callback)
    }
    
    public func replace (userDefinedFunctionWithId functionId: String, andBody function: String, from collection: DocumentCollection, callback: @escaping (Response<UserDefinedFunction>) -> ()) {
        
        let resourceUri = baseUri?.udf(atLink: collection.selfLink!, withResourceId: functionId)
        
        return self.replace(resourceWithId: functionId, andData: ["body":function], at: resourceUri, callback: callback)
    }
    
    
    
    
    
    // MARK: - Triggers
    
    // create
    public func create (triggerWithId triggerId: String, operation: Trigger.TriggerOperation, type triggerType: Trigger.TriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId)
        
        return self.create(Trigger.init(id: triggerId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, body: triggerBody, triggerOperation: operation, triggerType: triggerType), at: resourceUri, callback: callback)
    }
    
    public func create (triggerWithId triggerId: String, operation: Trigger.TriggerOperation, type triggerType: Trigger.TriggerType, andBody triggerBody: String, in collection: DocumentCollection, callback: @escaping (Response<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!, withResourceId: triggerId)
        
        return self.create(Trigger.init(id: triggerId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, body: triggerBody, triggerOperation: operation, triggerType: triggerType), at: resourceUri, callback: callback)
    }
    
    // list
    public func get (triggersIn collectionId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (triggersIn collection: DocumentCollection, callback: @escaping (ListResponse<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ trigger: Trigger, fromCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId, triggerId: trigger.id)
        
        return self.delete(Trigger.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ trigger: Trigger, from collection: DocumentCollection, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!, withResourceId: trigger.id)
        
        return self.delete(Trigger.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace (triggerWithId triggerId: String, operation: Trigger.TriggerOperation, type triggerType: Trigger.TriggerType, andBody triggerBody: String, inCollection collectionId: String, inDatabase databaseId: String, callback: @escaping (Response<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(databaseId, collectionId: collectionId, triggerId: triggerId)
        
        return self.replace(Trigger.init(id: triggerId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, body: triggerBody, triggerOperation: operation, triggerType: triggerType), at: resourceUri, callback: callback)
    }
    
    public func replace (triggerWithId triggerId: String, operation: Trigger.TriggerOperation, type triggerType: Trigger.TriggerType, andBody triggerBody: String, in collection: DocumentCollection, callback: @escaping (Response<Trigger>) -> ()) {
        
        let resourceUri = baseUri?.trigger(atLink: collection.selfLink!, withResourceId: triggerId)
        
        return self.replace(Trigger.init(id: triggerId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, body: triggerBody, triggerOperation: operation, triggerType: triggerType), at: resourceUri, callback: callback)
    }

    
    
    
    
    // MARK: - Users
    
    // create
    public func create (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (Response<User>) -> ()) {
        
        let resourceUri = baseUri?.user(databaseId)
        
        return self.create(resourceWithId: userId, at: resourceUri, callback: callback)
    }
    
    // list
    public func get (usersIn databaseId: String, callback: @escaping (ListResponse<User>) -> ()) {
        
        let resourceUri = baseUri?.user(databaseId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get (userWithId userId: String, inDatabase databaseId: String, callback: @escaping (Response<User>) -> ()) {
        
        let resourceUri = baseUri?.user(databaseId, userId: userId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ user: User, fromDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.user(databaseId, userId: user.id)
        
        return self.delete(User.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace (userWithId userId: String, with newUserId: String, inDatabase databaseId: String, callback: @escaping (Response<User>) -> ()) {
        
        let resourceUri = baseUri?.user(databaseId, userId: userId)
        
        return self.replace(resourceWithId: userId, at: resourceUri, callback: callback)
    }
    
    
    
    
    
    // MARK: - Permissions
    
    // create
    public func create (permissionWithId permissionId: String, mode permissionMode: Permission.PermissionMode, in resource: CodableResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(databaseId, userId: userId)
        
        let permission = Permission(id: permissionId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, permissionMode: permissionMode, resourceLink: resource.selfLink!, resourcePartitionKey: nil, token: nil)
        
        return self.create(permission, at: resourceUri, callback: callback)
    }
    
    public func create (permissionWithId permissionId: String, mode permissionMode: Permission.PermissionMode, in resource: CodableResource, forUser user: User, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(atLink: user.selfLink!, withResourceId: permissionId)

        let permission = Permission(id: permissionId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, permissionMode: permissionMode, resourceLink: resource.selfLink!, resourcePartitionKey: nil, token: nil)
        
        return self.create(permission, at: resourceUri, callback: callback)
    }
    
    // list
    public func get (permissionsFor userId: String, inDatabase databaseId: String, callback: @escaping (ListResponse<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(databaseId, userId: userId)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (permissionsFor user: User, callback: @escaping (ListResponse<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(atLink: user.selfLink!)
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get (permissionWithId permissionId: String, forUser userId: String, inDatabase databaseId: String, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permissionId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    public func get (permissionWithId permissionId: String, forUser user: User, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(atLink: user.selfLink!, withResourceId: permissionId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // delete
    public func delete (_ permission: Permission, forUser userId: String, inDatabase databaseId: String, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permission.id)
        
        return self.delete(Permission.self, resourceUri: resourceUri, callback: callback)
    }
    
    public func delete (_ permission: Permission, forUser user: User, callback: @escaping (DataResponse) -> ()) {
        
        let resourceUri = baseUri?.permission(atLink: user.selfLink!, withResourceId: permission.id)
        
        return self.delete(Permission.self, resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    public func replace (permissionWithId permissionId: String, mode permissionMode: Permission.PermissionMode, in resource: CodableResource, forUser userId: String, inDatabase databaseId: String, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(databaseId, userId: userId, permissionId: permissionId)
        
        let permission = Permission(id: permissionId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, permissionMode: permissionMode, resourceLink: resource.selfLink!, resourcePartitionKey: nil, token: nil)
        
        return self.create(permission, at: resourceUri, callback: callback)
    }
    
    public func replace (permissionWithId permissionId: String, mode permissionMode: Permission.PermissionMode, in resource: CodableResource, forUser user: User, callback: @escaping (Response<Permission>) -> ()) {
        
        let resourceUri = baseUri?.permission(atLink: user.selfLink!, withResourceId: permissionId)
        
        let permission = Permission(id: permissionId, resourceId: "", selfLink: nil, etag: nil, timestamp: nil, permissionMode: permissionMode, resourceLink: resource.selfLink!, resourcePartitionKey: nil, token: nil)
        
        return self.create(permission, at: resourceUri, callback: callback)
    }
    
    
    
    
    
    // MARK: - Offers
    
    // list
    public func offers (callback: @escaping (ListResponse<Offer>) -> ()) {
        
        let resourceUri = baseUri?.offer()
        
        return self.resources(resourceUri: resourceUri, callback: callback)
    }
    
    // get
    public func get (offerWithId offerId: String, callback: @escaping (Response<Offer>) -> ()) {
        
        let resourceUri = baseUri?.offer(offerId)
        
        return self.resource(resourceUri: resourceUri, callback: callback)
    }
    
    // replace
    
    // query
    
    
    
    
    
    // MARK: - Resources
    
    // create
    fileprivate func create<T> (_ resource: T, at resourceUri: (URL, String)?, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard resource.id.isValidResourceId else { callback(Response(invalidIdError)); return }
        
        return self.createOrReplace(resource, at: resourceUri, additionalHeaders: additionalHeaders, callback: callback)
    }

    fileprivate func create<T> (resourceWithId resourceId: String, andData data: [String:String?]? = nil, at resourceUri: (URL, String)?, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard resourceId.isValidResourceId else { callback(Response(invalidIdError)); return }
        
        var dict = data ?? [:]
        
        dict["id"] = resourceId

        return self.createOrReplace(dict, at: resourceUri, additionalHeaders: additionalHeaders, callback: callback)
    }
    
    // list
    fileprivate func resources<T> (resourceUri: (URL, String)?, callback: @escaping (ListResponse<T>) -> ()) {
        
        guard setup else { callback(ListResponse<T>(setupError)); return }
        
        let request = dataRequest(T.self, .get, resourceUri: resourceUri!)
        
        return self.sendRequest(request, callback: callback)
    }
    
    // get
    fileprivate func resource<T>(resourceUri: (URL, String)?, callback: @escaping (Response<T>) -> ()) {
        
        guard setup else { callback(Response<T>(setupError)); return }
        
        let request = dataRequest(T.self, .get, resourceUri: resourceUri!)
        
        return self.sendRequest(request, callback: callback)
    }
    
    // delete
    fileprivate func delete<T:CodableResource>(_ type: T.Type = T.self, resourceUri: (URL, String)?, callback: @escaping (DataResponse) -> ()) {
        
        guard setup else { callback(DataResponse(setupError)); return }
        
        let request = dataRequest(T.self, .delete, resourceUri: resourceUri!)
        
        return self.sendRequest(request, callback: callback)
    }
    
    // replace
    fileprivate func replace<T> (_ resource: T, at resourceUri: (URL, String)?, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard resource.id.isValidResourceId else { callback(Response(invalidIdError)); return }
        
        return self.createOrReplace(resource, at: resourceUri, replacing: true, additionalHeaders: additionalHeaders, callback: callback)
    }

    fileprivate func replace<T> (resourceWithId resourceId: String, andData data: [String:String]? = nil, at resourceUri: (URL, String)?, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard resourceId.isValidResourceId else { callback(Response(invalidIdError)); return }
        
        var dict = data ?? [:]
        
        dict["id"] = resourceId

        return self.createOrReplace(dict, at: resourceUri, replacing: true, additionalHeaders: additionalHeaders, callback: callback)
    }

    // query
    fileprivate func query<T> (_ query: Query, at resourceUri: (URL, String)?, callback: @escaping (ListResponse<T>) -> ()) {
        
        guard setup else { callback(ListResponse<T>(setupError)); return }
        
        if self.verboseLogging { query.printQuery(); print() }
        
        do {
            
            var request = dataRequest(T.self, .post, resourceUri: resourceUri!, forQuery: true)
        
            request.httpBody = try jsonEncoder.encode(query)
            
            return self.sendRequest(request, callback: callback)
            
        } catch {
            callback(ListResponse(ADError(error))); return
        }
    }
    
    // execute
    fileprivate func execute<T:CodableResource, R: Encodable>(_ type: T.Type, withBody body: R? = nil, resourceUri: (URL, String)?, callback: @escaping (DataResponse) -> ()) {
        
        guard setup else { callback(DataResponse(setupError)); return }
        
        do {
            
            var request = dataRequest(type.self, .post, resourceUri: resourceUri!)
            
            request.httpBody = body == nil ? try jsonEncoder.encode([String]()) : try jsonEncoder.encode(body)

            return self.sendRequest(request, callback: callback)
            
        } catch {
            callback(DataResponse(ADError(error))); return
        }
    }
    
    // create or replace
    fileprivate func createOrReplace<T, R:Encodable> (_ body: R, at resourceUri: (URL, String)?, replacing: Bool = false, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard setup else { callback(Response<T>(setupError)); return }
        
        do {
            
            var request = dataRequest(T.self, replacing ? .put : .post, resourceUri: resourceUri!, additionalHeaders: additionalHeaders)
            
            request.httpBody = try jsonEncoder.encode(body)
            
            return self.sendRequest(request, callback: callback)
            
        } catch {
            callback(Response(ADError(error))); return
        }
    }
    
    fileprivate func createOrReplace<T> (_ body: Data, at resourceUri: (URL, String)?, replacing: Bool = false, additionalHeaders: [String:HttpRequestHeader]? = nil, callback: @escaping (Response<T>) -> ()) {
        
        guard setup else { callback(Response<T>(setupError)); return }
        
        var request = dataRequest(T.self, replacing ? .put : .post, resourceUri: resourceUri!, additionalHeaders: additionalHeaders)
        
        request.httpBody = body
        
        return self.sendRequest(request, callback: callback)
    }


    

    
    // MARK: - Request
    
    fileprivate func sendRequest<T> (_ request: URLRequest, callback: @escaping (Response<T>) -> ()) {
        
        if verboseLogging {
            print("***")
            print("Sending \(request.httpMethod ?? "") request for \(T.self) to \(request.url?.absoluteString ?? "")")
            print("\tBody : \(request.httpBody != nil ? String(data: request.httpBody!, encoding: .utf8) ?? "empty" : "empty")")
        }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                if self.verboseLogging { print("❌ error: \(error.localizedDescription)"); print() }
                
                callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error))))
            
            } else if let data = data {
                
                //if self.verboseLogging { print("*** data: \(String(data: data, encoding: .utf8) ?? "nil")") }
                
                do {
                    
                    let resource = try self.jsonDecoder.decode(T.self, from: data)
                    
                    if self.verboseLogging { print(resource); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .success(resource)))
                    
                } catch DecodingError.typeMismatch(let type, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: typeMismatch (type: \(type), context: \(context)"); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: typeMismatch (type: \(type), context: \(context)"))))
                    
                } catch DecodingError.dataCorrupted(let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: dataCorrupted (context: \(context)"); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: dataCorrupted (context: \(context)"))))
                    
                } catch DecodingError.keyNotFound(let key, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: keyNotFound (key: \(key), context: \(context)"); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: keyNotFound (key: \(key), context: \(context)"))))
                    
                } catch DecodingError.valueNotFound(let type, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: valueNotFound (type: \(type), context: \(context)"); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: valueNotFound (type: \(type), context: \(context)"))))
                    
                } catch let e {
                    
                    if self.verboseLogging { print("❌ decodeError: \(e.localizedDescription)"); print() }
                    
                    callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(e))))
                }
            } else {
                
                if self.verboseLogging { print("❌ error: \(self.unknownError.message)"); print() }
                
                callback(Response(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(self.unknownError)))
            }
        }.resume()
    }

    fileprivate func sendRequest<T> (_ request: URLRequest, callback: @escaping (ListResponse<T>) -> ()) {
        
        if verboseLogging {
            print("***")
            print("Sending \(request.httpMethod ?? "") request for \(T.self) List to \(request.url?.absoluteString ?? "")")
            print("\tBody : \(request.httpBody != nil ? String(data: request.httpBody!, encoding: .utf8) ?? "empty" : "empty")")
        }

        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                if self.verboseLogging { print("❌ error: \(error.localizedDescription)") }
                
                callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error))))
                
            } else if let data = data {
                
                //if self.verboseLogging { print("*** data: \(String(data: data, encoding: .utf8) ?? "nil")") }
                
                do {
                    
                    let resource = try self.jsonDecoder.decode(Resources<T>.self, from: data)
                    
                    if self.verboseLogging { print(resource); print() }
                    
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .success(resource)))
                    
                } catch DecodingError.typeMismatch(let type, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: typeMismatch (type: \(type), context: \(context)"); print() }
                 
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: typeMismatch (type: \(type), context: \(context)"))))
                
                } catch DecodingError.dataCorrupted(let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: dataCorrupted (context: \(context)"); print() }
                    
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: dataCorrupted (context: \(context)"))))

                } catch DecodingError.keyNotFound(let key, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: keyNotFound (key: \(key), context: \(context)"); print() }
                    
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: keyNotFound (key: \(key), context: \(context)"))))

                } catch DecodingError.valueNotFound(let type, let context) {
                    
                    if self.verboseLogging { print("❌ decodeError: valueNotFound (type: \(type), context: \(context)"); print() }
                    
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError("decodeError: valueNotFound (type: \(type), context: \(context)"))))

                } catch let e {
                    
                    if self.verboseLogging { print("❌ decodeError: \(e.localizedDescription)"); print() }
                    
                    callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(e))))
                }
            } else {
                
                if self.verboseLogging { print("❌ error: \(self.unknownError.message)"); print() }
             
                callback(ListResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(self.unknownError)))
            }
        }.resume()
    }
    
    fileprivate func sendRequest (_ request: URLRequest, callback: @escaping (DataResponse) -> ()) {
        
        if verboseLogging {
            print("***")
            print("Sending \(request.httpMethod ?? "") request for Data to \(request.url?.absoluteString ?? "")")
            print("\tBody : \(request.httpBody != nil ? String(data: request.httpBody!, encoding: .utf8) ?? "empty" : "empty")")
        }

        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                if self.verboseLogging { print("❌ error: \(error.localizedDescription)"); print() }
                
                callback(DataResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(ADError(error))))

            } else if let data = data {
                
                if self.verboseLogging { print("Data : \(String(data: data, encoding: .utf8) ?? "nil")"); print() }

                callback(DataResponse.init(request: request, response: response as? HTTPURLResponse, data: data, result: .success(data)))
                
            } else {
                
                if self.verboseLogging { print("❌ error: \(self.unknownError.message)"); print() }

                callback(DataResponse(request: request, response: response as? HTTPURLResponse, data: data, result: .failure(self.unknownError)))
            }
        }.resume()
    }
    
    fileprivate func dataRequest<T:CodableResource>(_ type: T.Type = T.self, _ method: HttpMethod, resourceUri: (url:URL, link:String),  additionalHeaders:[String:HttpRequestHeader]? = nil, forQuery: Bool = false) -> URLRequest {
        
        let (token, date) = tokenProvider.getToken(type, verb: method, resourceLink: resourceUri.link)
        
        var request = URLRequest(url: resourceUri.url)
        
        request.method = method
        
        request.addValue(date, forHTTPHeaderField: .xMSDate)
        request.addValue(token, forHTTPHeaderField: .authorization)
        
        if forQuery {
            
            request.addValue ("true", forHTTPHeaderField: .xMSDocumentdbIsQuery)
            request.addValue("application/query+json", forHTTPHeaderField: .contentType)
            
        } else if (method == .post || method == .put) && type.type != Attachment.type {
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
