//
//  ADTokenProvider.swift
//  AzureData
//
//  Created by Colby Williams on 10/17/17.
//  Copyright © 2017 Colby Williams. All rights reserved.
//

import Foundation
import CommonCrypto


public enum ADTokenType: String {
    case master = "master"
    case resource = "resource"
}

public enum ADTokenError : Error {
    case base64KeyError
}

public class ADTokenProvider {
    
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
    
    public init(key k: String, keyType type: ADTokenType = .master, tokenVersion version: String = "1.0") {
        key = k
        keyType = type.rawValue
        tokenVersion = version
    }
    
    // https://docs.microsoft.com/en-us/rest/api/documentdb/access-control-on-documentdb-resources#constructkeytoken
    public func getToken(verb v: ADHttpMethod, resourceType type: ADResourceType, resourceLink link: String) -> (String, String) {
        
        let verb = v.rawValue
        let resourceType = type.rawValue
        let resourceLink = link
        
        let dateString = dateFormatter.string(from: Date())
        
        let payload = "\(verb.lowercased())\n\(resourceType.lowercased())\n\(resourceLink)\n\(dateString.lowercased())\n\n"
        
        print(payload)
        
        let signiture = payload.hmac(algorithm: .SHA256, key: key)
        
        let authString = "type=\(keyType)&ver=\(tokenVersion)&sig=\(signiture)"
        
        let authStringEncoded = authString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
        
        return (authStringEncoded, dateString)
    }
}

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        
        let keyData = NSData(base64Encoded: key, options: .ignoreUnknownCharacters)!
        
        var data = self.data(using: .utf8, allowLossyConversion: false)
        
        return data?.withUnsafeBytes{ (bytes: UnsafePointer<CUnsignedChar>) -> String in
            
            let hashResult = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength())
            
            CCHmac(algorithm.toCCHmacAlgorithm(), keyData.bytes, Int(keyData.length), bytes, Int(data!.count), hashResult)
            
            let hash = NSData(bytes: hashResult, length: algorithm.digestLength())
            
            let hashString = hash.base64EncodedString(options: NSData.Base64EncodingOptions([]))
            
            hashResult.deinitialize()
            
            return hashString
        
        } ?? ""
        
        
//      let cKey = key.cString(using: String.Encoding.utf8)
//
//      let cData = self.cString(using: String.Encoding.utf8)
//
//      var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
//
//      CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
//
//      let hmacData:NSData = NSData(bytes: result, length: algorithm.digestLength())
//
//      let hmacBase64 = hmacData.base64EncodedString(options: NSData.Base64EncodingOptions([]))
//
//      print(hmacBase64)
//
//      return String(hmacBase64)
    }
}

















