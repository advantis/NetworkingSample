//
//  NWBaseRequestModel.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWBaseRequestModel.h"
#import "NWStrucutreAndTypes.h"


#pragma mark Public interface implementation

@implementation NWBaseRequestModel


#pragma mark - Instance methods

- (NSString *)resourcePath {
    
    return nil;
}

- (NSString *)resourceMIMEType {
    
    return NWResourceMIMEType.JSON;
}

- (NSDictionary *)parameters {
    
    return nil;
}

- (NSDictionary *)headers {
    
    return @{@"Content-Type":[self resourceMIMEType]};
}

- (NSString *)method {
    
    return @"GET";
}

- (id<NWResponseParserProtocol>)parser {
    
    return nil;
}

#pragma mark -


@end
