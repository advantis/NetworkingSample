

#import "AFImageCache.h"

#import "UIImageView+AFNetworking.h"

#pragma mark -

@interface UIImage (NSCacheExtension)

- (NSUInteger)cacheCost;

@end;

@implementation UIImage (NSCacheExtension)

/**
* Cost calculation based on size of pixel in bitmap.
*/
- (NSUInteger)cacheCost {
	size_t bytesPerPixel = CGImageGetBitsPerPixel(self.CGImage) / 8;
	return (NSUInteger)(self.size.width * self.size.height * bytesPerPixel);
}

@end

#pragma mark -

@interface AFImageCache ()
/**
*	Use NSCache for in-memory storage to prevent memory overhead.
*	By default NSURLCache don't purge allocated memory on memory warning.
*	Combination of NSCache & NSURLCache for on disk storage only gives us nice memory usage
*	and on-disk cache.
*/
@property (nonatomic, strong) NSCache *inMemoryCache;

@end

@implementation AFImageCache

#pragma mark - Init

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity
				diskCapacity:(NSUInteger)diskCapacity
					diskPath:(NSString *)path {
	// using 1 byte as a trick, because when 0 - cache behaves very strange (ie not back to disk anything)
	self = [super initWithMemoryCapacity:1024 diskCapacity:diskCapacity diskPath:path];
	if (self) {
		self.inMemoryCache = [NSCache new];
		[self.inMemoryCache setTotalCostLimit:memoryCapacity];
	}
	return self;
}

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity {
	[self.inMemoryCache setTotalCostLimit:memoryCapacity];
}

#pragma mark - Public

- (UIImage *)cachedImageForURL:(NSURL *)url {
	NSMutableURLRequest *request = [NSMutableURLRequest af_imageRequestWithURL:url];
	return [self cachedImageForRequest:request];
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
	UIImage *imMemoryImage = [self.inMemoryCache objectForKey:request];
	if (imMemoryImage) return imMemoryImage;

	// retrieve on-disk image data
	NSCachedURLResponse *cachedURLResponse = [self cachedResponseForRequest:request];
	if (cachedURLResponse != nil) {
		UIImage *onDiskImage = [UIImage imageWithData:cachedURLResponse.data];

		// save encoded image to in-memory cache also
		if (onDiskImage) {
			[self.inMemoryCache setObject:onDiskImage forKey:request cost:[onDiskImage cacheCost]];
		}

		return onDiskImage;
	}

	return nil;
}

- (void)cacheImageOperationResponse:(AFImageRequestOperation *)operation {
	if (operation.error != nil) return;

	UIImage *responseImage = operation.responseImage;
	// save to in-memory cache
	[self.inMemoryCache setObject:responseImage forKey:operation.request cost:[responseImage cacheCost]];

	// save to on-disk cache
	NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response
																					  data:operation.responseData];
	[self storeCachedResponse:cachedURLResponse forRequest:operation.request];
}

@end