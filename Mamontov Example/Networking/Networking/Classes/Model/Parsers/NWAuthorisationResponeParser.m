//
//  NWAuthorisationResponeParser.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAuthorisationResponeParser.h"
#import "NWProfile+Protected.h"


#pragma mark Public interface implementatino

@implementation NWAuthorisationResponeParser


#pragma mark - Instance methods

- (id)parseData:(id)response {
    
    return [[NWProfile alloc] initWithData:response];
}


#pragma mark -


@end
