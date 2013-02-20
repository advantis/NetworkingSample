
#import "WNHTTPClient.h"

#import "AFNetworkActivityIndicatorManager.h"

#import "AFJSONRequestOperation.h"

@implementation WNHTTPClient

#pragma mark - Init API

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        [self.operationQueue setMaxConcurrentOperationCount:WNHTTPClientMaxConcurrentOperations];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

+ (id)defaultClient
{
    static WNHTTPClient *defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        defaultClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WNHTTPClientBaseURL]];
    });
    
    return defaultClient;
}

#pragma mark - Public API

- (AFJSONRequestOperation *)enqueueJSONRequestOperationWithMethod:(NSString *)method
                                                         path:(NSString *)path
                                                       params:(NSDictionary *)params
{
    return [self enqueueJSONRequestOperationWithMethod:method path:path params:params dependencies:nil];
}

- (AFJSONRequestOperation *)enqueueJSONRequestOperationWithMethod:(NSString *)method
															 path:(NSString *)path
														   params:(NSDictionary *)params
													 dependencies:(NSArray *)dependencies
{
	NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:params];
	AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
	[operation addDependencies:dependencies];

	[self enqueueHTTPRequestOperation:operation];

	return operation;
}

@end
