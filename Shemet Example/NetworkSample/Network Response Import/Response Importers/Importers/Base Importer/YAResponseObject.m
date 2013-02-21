//
// Created by dmitriy on 21.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YAResponseObject.h"

@interface YAResponseObject ()

@property (nonatomic, strong) NSArray *data;


@end

@implementation YAResponseObject

#pragma mark - Init

- (void)dealloc
{
	[self setCallbackQueue:nil];
}

- (id)initWithData:(NSArray *)data
	 callbackQueue:(dispatch_queue_t)callbackQueue
	 beginCallback:(YAResponseObjectCallback)beginCallback
	   endCallback:(YAResponseObjectCallback)endCallback
{
	NSParameterAssert(data != nil);

	self = [super init];
	if (self != nil)
	{
		[self setData:data];
		[self setImportBeginCallback:beginCallback];
		[self setImportEndCallback:endCallback];
		[self setCallbackQueue:callbackQueue];
	}

	return self;
}

- (id)initWithData:(NSArray *)data endCallback:(YAResponseObjectCallback)endCallback
{
	return [self initWithData:data callbackQueue:nil beginCallback:nil endCallback:endCallback];
}


+ (instancetype)objectWithData:(NSArray *)data endCallback:(YAResponseObjectCallback)endCallback
{
	return [[self alloc] initWithData:data endCallback:endCallback];
}

#pragma mark - Properties

- (void)setCallbackQueue:(dispatch_queue_t)callbackQueue
{
	if (_callbackQueue != nil)
	{
		dispatch_release(_callbackQueue);
		_callbackQueue = nil;
	}

	if (callbackQueue != nil)
	{
		dispatch_retain(callbackQueue);
		_callbackQueue = callbackQueue;
	}
}

@end