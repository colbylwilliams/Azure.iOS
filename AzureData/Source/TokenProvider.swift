//
//  TokenProvider.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation
//import CommonCrypto

public enum TokenType: String {
    case master = "master"
    case resource = "resource"
}

public enum TokenError : Error {
    case base64KeyError
}

public class TokenProvider {
    
    let key: String
    let keyType: String
    let tokenVersion: String
    
    let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()
    
    public init(key k: String, keyType type: TokenType = .master, tokenVersion version: String = "1.0") {
        key = k
        keyType = type.rawValue
        tokenVersion = version
    }
    
    // https://docs.microsoft.com/en-us/rest/api/documentdb/access-control-on-documentdb-resources#constructkeytoken
    public func getToken(verb v: HttpMethod, resourceType type: ResourceType, resourceLink link: String) -> (String, String) {
        
        print("getToken")
        
        let verb = v.rawValue
        let resourceType = type.rawValue
        let resourceLink = link
        
        let dateString = dateFormatter.string(from: Date())
        
        let payload = "\(verb.lowercased())\n\(resourceType.lowercased())\n\(resourceLink)\n\(dateString.lowercased())\n\n"
        
        print("payload:\n\(payload)")
        
        let signiture = payload.hmac(key: key)
        // let signiture = payload.hmac(algorithm: .SHA256, key: key)
        
        print("signiture:\n\(signiture)")
        
        let authString = "type=\(keyType)&ver=\(tokenVersion)&sig=\(signiture)"
        
        print("authString:\n\(authString)")
        
        let authStringEncoded = authString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
        
        print("authStringEncoded:\n\(authStringEncoded)")
        
        return (authStringEncoded, dateString)
    }
    
    
    public func getToken<T:CodableResource>(_ type: T.Type = T.self, verb v: HttpMethod, resourceLink link: String) -> (String, String) {
        
        print("getToken T")
        
        let verb = v.rawValue
        let resourceType = type.type
        let resourceLink = link

        let dateString = dateFormatter.string(from: Date())

//        let verb = "post"
//        let resourceType = "dbs"
//        let resourceLink = ""
//
//        let dateString = "mon, 08 jan 2018 22:25:43 gmt"

        let payload = "\(verb.lowercased())\n\(resourceType.lowercased())\n\(resourceLink)\n\(dateString.lowercased())\n\n"
        
        print("payload:\n\(payload)")
        
        let signiture = payload.hmac(key: key)
        // let signiture = payload.hmac(algorithm: .SHA256, key: key)
        
        print("signiture: \(signiture)")
        
        let authString = "type=\(keyType)&ver=\(tokenVersion)&sig=\(signiture)"
        
        print("authString: \(authString)")
        
        let authStringEncoded = authString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
        
        print("authStringEncoded: \(authStringEncoded)")
        
        return (authStringEncoded, dateString)
    }
}


extension String {

    func hmac(key: String) -> String {

        let keyData = NSData(base64Encoded: key, options: .ignoreUnknownCharacters)!

        let data = self.data(using: .utf8, allowLossyConversion: false)

        return data?.withUnsafeBytes{ (bytes: UnsafePointer<CUnsignedChar>) -> String in

            let hash = keyData.ccHmac(withBytes: bytes)!

            let hashString = hash.base64EncodedString(options: NSData.Base64EncodingOptions([]))

            return hashString

        } ?? ""
    }
}
