//
//  NSData+CCHmac.h
//  AzureData
//
//  Created by Colby L Williams on 1/8/18.
//  Copyright © 2018 Colby Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CCHmac)

- (NSData *)CCHmacWithBytes:(const unsigned char *) bytes;

@end
