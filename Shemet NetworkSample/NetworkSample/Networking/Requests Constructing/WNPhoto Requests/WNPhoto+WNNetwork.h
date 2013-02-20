
#import "WNPhoto.h"

#import "WNHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface WNPhoto (WNNetwork)

/**
* Construct and initiate query for photos fetch.
*/
+ (AFJSONRequestOperation *)initiatePhotoFetchOperationsWithOffset:(NSUInteger)offset;

+ (AFJSONRequestOperation *)fetchPhotosWithOffset:(NSUInteger)offset
									asInitial:(BOOL)asInitial
									onSuccess:(void (^)(NSArray *))successCallback
									onFailure:(void (^)(NSError *))failureCallback;

@end
