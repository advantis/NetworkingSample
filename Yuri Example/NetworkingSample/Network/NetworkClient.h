//
//  Copyright © 2013 Yuri Kotov
//

#import "AFNetworking.h"

@interface NetworkClient : AFHTTPClient

+ (instancetype) sharedClient;

@end