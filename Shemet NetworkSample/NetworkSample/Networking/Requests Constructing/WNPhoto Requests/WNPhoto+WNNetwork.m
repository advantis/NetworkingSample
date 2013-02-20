
#import "WNPhoto+WNNetwork.h"

#import "WNPhoto+WNPrimaryImport.h"

@implementation WNPhoto (WNNetwork)

+ (AFJSONRequestOperation *)initiatePhotoFetchOperationsWithOffset:(NSUInteger)offset
{
	return [[WNHTTPClient defaultClient] enqueueJSONRequestOperationWithMethod:@"GET"
																		  path:@"photo.json"
																		params:@{@"offset" : @(offset)}];
}

+ (AFJSONRequestOperation *)fetchPhotosWithOffset:(NSUInteger)offset
										asInitial:(BOOL)asInitial
										onSuccess:(void (^)(NSArray *))successCallback
										onFailure:(void (^)(NSError *))failureCallback
{
	AFJSONRequestOperation *requestOperation = [self initiatePhotoFetchOperationsWithOffset:offset];

	[requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		[WNPhoto importPhotosResponse:responseObject asInitial:asInitial callback:^(BOOL success, NSArray *IDs)
		{
			if (successCallback != nil) successCallback(IDs);
		}];

	} failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		if (failureCallback != nil) failureCallback(error);
	}];

	return	requestOperation;
}


@end