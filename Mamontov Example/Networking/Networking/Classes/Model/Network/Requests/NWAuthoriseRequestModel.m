//
//  NWAuthoriseRequestModel.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAuthoriseRequestModel.h"
#import "NWAuthorisationResponeParser.h"
#import "Base64.h"


#pragma mark Private interface declaration

@interface NWAuthoriseRequestModel ()


#pragma mark - Properties

@property (nonatomic, copy) NSString *resourcePath;
@property (nonatomic, copy) NSString *authorisationToken;


#pragma mark - Instance methods

- (instancetype)initWithUsername:(NSString *)username andPassword:(NSString *)password;


@end


#pragma mark - Public interface methods

@implementation NWAuthoriseRequestModel


#pragma mark - Class methods

+ (instancetype)authoriseModelWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    return [[self alloc] initWithUsername:username andPassword:password];
}


#pragma mark - Instance methods

- (instancetype)initWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    // Check whether initialization was successful or not
    if((self = [super init])) {
        
        self.authorisationToken = [[NSString stringWithFormat:@"%@:%@", username, password] base64EncodedString];
        self.resourcePath = @"auth/1/session";
    }
    
    
    return self;
}

- (NSDictionary *)headers {
    
    NSMutableDictionary *headers = [[super headers] mutableCopy];
    
    [headers setValuesForKeysWithDictionary:@{@"Authorization":[NSString stringWithFormat:@"Basic %@", self.authorisationToken]}];
    
    
    return headers;
}

- (id<NWResponseParserProtocol>)parser {
    
    return [NWAuthorisationResponeParser new];
}

#pragma mark -


@end
