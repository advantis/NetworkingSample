//
//  NWAPIClient.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "AFHTTPClient.h"
#import "NWStrucutreAndTypes.h"
#import "NWRequestProtocol.h"


@interface NWAPIClient : AFHTTPClient


#pragma mark Class methods

+ (instancetype)sharedInstance;


#pragma mark - Instance methods

#pragma mark - Requests execution

- (void)performRequest:(id<NWRequestProtocol>)request
    withSuccessHandler:(NWRequestComletionBlock)successBlock
          errorHandler:(void(^)(NSError *))errorBlock;


#pragma mark -


@end
