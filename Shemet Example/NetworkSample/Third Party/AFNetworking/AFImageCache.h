
#import <Foundation/NSURLCache.h>

#import "AFImageRequestOperation.h"

@interface AFImageCache : NSURLCache

/**
* This method use url for request constructing NSMutableURLRequest+AFNetworking
*/
- (UIImage *)cachedImageForURL:(NSURL *)url;

/**
* Return previously cached image from memory or disk storage
*/
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;

/**
* Handling of AFImageRequestOperation caching.
* Usage of -[NSURLCache storeCachedResponse:forRequest:] will lead to unexpected behaviour
*/
- (void)cacheImageOperationResponse:(AFImageRequestOperation *)operation;

@end
