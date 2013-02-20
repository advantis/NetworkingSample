//
//  Copyright © 2013 Yuri Kotov
//

#import "SignUpOperation.h"
#import "AFHTTPRequestOperation+Perform.h"
#import "NetworkClient.h"

@implementation SignUpOperation

+ (id) new
{
    NSMutableURLRequest *request = [[NetworkClient sharedClient] requestWithMethod:@"POST"
                                                                              path:@"signup"
                                                                        parameters:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return [[self alloc] initWithRequest:request];
}

- (void) perform
{
    NSString *birthday = [_birthday description];
    NSString *gender = _male ? @"male" : @"female";
    NSDictionary *params = @{
        @"email"    : _email,
        @"password" : _password,
        @"birthday" : birthday,
        @"gender"   : gender
    };

    __autoreleasing NSError *error;
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    self.inputStream = [NSInputStream inputStreamWithData:body];

    [super perform];
}

@end