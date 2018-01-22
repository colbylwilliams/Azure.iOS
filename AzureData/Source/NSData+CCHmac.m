//
//  NSString+CCHmac.m
//  AzureData
//
//  Created by Colby L Williams on 1/8/18.
//  Copyright © 2018 Colby Williams. All rights reserved.
//

#import "NSData+CCHmac.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (CCHmac)

- (NSData *)CCHmacWithBytes:(const unsigned char *) bytes {
    
    unsigned char hashResult[CC_SHA256_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA256, self.bytes, self.length, bytes, strlen((char*)bytes), hashResult);
    
    NSData *hash = [[NSData alloc] initWithBytes:hashResult length:sizeof(hashResult)];
    
    return hash;
}

@end
