//
//  Copyright © 2013 Yuri Kotov
//

#import "AFHTTPRequestOperation+Init.h"
#import "NetworkClient.h"

@implementation AFHTTPRequestOperation (Init)

- (id) usageSample __unused
{
    id email, password;
    NSDictionary *params = @{
        @"email"    : email,
        @"password" : password
    };

    ConfigurationBlock block = ^(AFHTTPRequestOperation *operation) {
        [operation setCompletionBlockWithSuccess:nil failure:nil];
    };

    return [self initWithMethod:@"POST" path:@"signin" parameters:params configurationBlock:block];
}

- (id) initWithMethod:(NSString *)method
                 path:(NSString *)path
           parameters:(NSDictionary *)params
   configurationBlock:(ConfigurationBlock)block
{
    NSURLRequest *request = [[NetworkClient sharedClient] requestWithMethod:method path:path parameters:params];
    AFHTTPRequestOperation *operation = [self initWithRequest:request];
    block(operation);
    return operation;
}

@end