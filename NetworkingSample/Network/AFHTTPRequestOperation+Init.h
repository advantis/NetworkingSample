//
//  Copyright © 2013 Yuri Kotov
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^ConfigurationBlock)(id operation);

@interface AFHTTPRequestOperation (Init)

- (id) initWithMethod:(NSString *)method
                 path:(NSString *)path
           parameters:(NSDictionary *)params
   configurationBlock:(ConfigurationBlock)block;

@end