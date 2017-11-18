//
//  DocumentClientError.swift
//  AzureData
//
//  Created by Colby L Williams on 11/18/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation

public struct DocumentClientError : Error {
    
    /// Gets the activity ID associated with the request from the Azure Cosmos DB service.
    public let activityId: String?

    /// Gets the error code associated with the exception in the Azure Cosmos DB service.
    public let resourceError: ResourceError?
    
    /// Gets a message that describes the current exception from the Azure Cosmos DB service.
    public let message: String?
    
    /// Cost of the request in the Azure Cosmos DB service.
    public let requestCharge: Double?
    
    /// Gets the headers associated with the response from the Azure Cosmos DB service.
    public let responseHeaders: [HttpResponseHeader:Any]?
    
    /// Gets the recommended time interval after which the client can retry failed requests from the Azure Cosmos DB service
    public let retryAfter: TimeInterval?
    
    /// Gets or sets the request status code in the Azure Cosmos DB service.
    public let statusCode: StatusCode?
    
    
    init(withMessage message: String?) {
        self.activityId = nil
        self.resourceError = nil
        self.message = message
        self.requestCharge = nil
        self.responseHeaders = nil
        self.retryAfter = nil
        self.statusCode = nil
    }
    
    
    init(withData data: Data?, response: URLResponse?, andError error: Error?) {
        
        if let response = response as? HTTPURLResponse {
            
            var headers = [HttpResponseHeader:Any]()
            
            for header in response.allHeaderFields {
                if let keyString = header.key as? String, let responseHeader = HttpResponseHeader(rawValue: keyString) {
                    headers[responseHeader] = header.value
                }
            }
            
            self.responseHeaders = headers

            self.activityId = headers[.xMsActivityId] as? String
            self.requestCharge = headers[.xMsRequestCharge] as? Double
            self.retryAfter = headers[.xMsRetryAfterMs] as? Double
            self.statusCode = StatusCode(rawValue: response.statusCode)
        } else {
            self.activityId = nil
            self.requestCharge = nil
            self.responseHeaders = nil
            self.retryAfter = nil
            self.statusCode = nil
        }

        if let data = data, let resourceError = try? ResourceError.decode(data: data) {
            self.resourceError = resourceError
            self.message = resourceError.message
        } else {
            self.resourceError = nil
            self.message = nil
        }
    }
}


extension DocumentClientError {
    static let unknownError     = DocumentClientError(withMessage: "A unknown error occured.")
    static let setupError       = DocumentClientError(withMessage: "AzureData is not setup.  Must call AzureData.setup() before attempting CRUD operations on resources.")
    static let invalidIdError   = DocumentClientError(withMessage: "Cosmos DB Resource IDs must not exceed 255 characters and cannot contain whitespace")
    static let jsonError        = DocumentClientError(withMessage: "Error: Could not serialize document to JSON")
    static let incompleteIds    = DocumentClientError(withMessage: "This resource is missing the selfLink and/or resourceId properties.  Use an override that takes parent resource or ids instead.")
}
