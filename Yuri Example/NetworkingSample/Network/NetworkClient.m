//
//  Copyright © 2013 Yuri Kotov
//

#import "NetworkClient.h"

static NSString * const BaseURL = @"http://google.com/complete";

@implementation NetworkClient

#pragma mark - ADVNetworkClient
+ (instancetype) sharedClient
{
    static NetworkClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [self new]; });
    return instance;
}

#pragma mark - NSObject
- (id) init
{
    return [self initWithBaseURL:[NSURL URLWithString:BaseURL]];
}

@end