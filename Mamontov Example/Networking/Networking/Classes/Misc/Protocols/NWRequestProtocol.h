//
//  NWRequestProtocol.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWResponseParserProtocol.h"


@protocol NWRequestProtocol <NSObject>


@required

/**
 * Retrieve reference on composed path to the resource
 * (it can be REST resource path or path to the API with 
 * specified set of parameters)
 */
- (NSString *)resourcePath;

- (NSString *)resourceMIMEType;
- (NSDictionary *)parameters;
- (NSDictionary *)headers;
- (NSString *)method;


/**
 * Returns reference on request's response parser instance
 */
- (id<NWResponseParserProtocol>)parser;

#pragma mark -


@end
