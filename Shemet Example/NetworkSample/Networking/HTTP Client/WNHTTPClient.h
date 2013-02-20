

#import "AFHTTPClient.h"

static NSString * const WNHTTPClientBaseURL = @"http://api.server.com/";
static const NSUInteger WNHTTPClientMaxConcurrentOperations = 5;

@class AFJSONRequestOperation;

@interface WNHTTPClient : AFHTTPClient

+ (id)defaultClient;

- (AFJSONRequestOperation *)enqueueJSONRequestOperationWithMethod:(NSString *)method
                                                             path:(NSString *)path
                                                           params:(NSDictionary *)params;

/**
* Creates & enqueues network operation with respect of passed dependencies;
* Dependencies array contains NSOperations, that are in dependency.
* For more details check NSOperation Reference: -dependencies.
*/
- (AFJSONRequestOperation *)enqueueJSONRequestOperationWithMethod:(NSString *)method
															 path:(NSString *)path
														   params:(NSDictionary *)params
													 dependencies:(NSArray *)dependencies;

@end
