//
//  NWAPIClient.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "NWStrucutreAndTypes.h"


#pragma mark Static

static NSString * const kNWBaseAPIURLString = @"http://dev.yalantis.com/jira/rest";


#pragma mark - Private interface declaration

@interface NWAPIClient ()


#pragma mark - Instance methods

#pragma mark - Misc methods

/**
 * Return operation which will be best for request's resource MIME type
 */
- (AFHTTPRequestOperation *)operationForModel:(id<NWRequestProtocol>)requestModel;

/**
 * Compose actual request which will be passed for processing
 */
- (NSMutableURLRequest *)requestFromModel:(id<NWRequestProtocol>)requestModel;

@end


#pragma mark - Public interface implementation

@implementation NWAPIClient


#pragma mark - Class methods

+ (instancetype)sharedInstance {
    
    static NWAPIClient *_sharedInstange;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstange = [self new];
    });
    
    
    return _sharedInstange;
}


#pragma mark - Instance methods

- (id)init {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    return [self initWithBaseURL:[NSURL URLWithString:kNWBaseAPIURLString]];
}

#pragma mark - Requests execution

- (void)performRequest:(id<NWRequestProtocol>)request
    withSuccessHandler:(NWRequestComletionBlock)successBlock
          errorHandler:(void(^)(NSError *))errorBlock {
    
    AFHTTPRequestOperation *operation = [self operationForModel:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                                        if (successBlock) {
                                            
                                            successBlock([[request parser] parseData:responseObject]);
                                        }
                                    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         if (errorBlock) {
                                             
                                             errorBlock(error);
                                         }
                                     }];
    
    [operation start];
}

#pragma mark - Misc methods

- (AFHTTPRequestOperation *)operationForModel:(id<NWRequestProtocol>)request {
    
    Class operationClass = [AFHTTPRequestOperation class];
    
    if ([[request resourceMIMEType] isEqualToString:NWResourceMIMEType.JSON]) {
        
        operationClass = [AFJSONRequestOperation class];
    }
    
    
    return [[operationClass alloc] initWithRequest:[self requestFromModel:request]];
}

- (NSMutableURLRequest *)requestFromModel:(id<NWRequestProtocol>)requestModel {
    
    NSMutableURLRequest *request = [self requestWithMethod:[requestModel method]
                                                      path:[requestModel resourcePath]
                                                parameters:[requestModel parameters]];
    [request setAllHTTPHeaderFields:[requestModel headers]];
    
    
    return request;
}

#pragma mark -


@end
