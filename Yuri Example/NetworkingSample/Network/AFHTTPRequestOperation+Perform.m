//
//  Copyright © 2013 Yuri Kotov
//

#import "AFHTTPRequestOperation+Perform.h"
#import "NetworkClient.h"

@implementation AFHTTPRequestOperation (Perform)

- (void) perform
{
    [[NetworkClient sharedClient] enqueueHTTPRequestOperation:self];
}

@end