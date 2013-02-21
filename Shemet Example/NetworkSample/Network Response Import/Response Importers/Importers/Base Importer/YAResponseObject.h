//
// Created by dmitriy on 21.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@class YAResponseImporter, YAResponseObject;

typedef void (^YAResponseObjectCallback)(YAResponseImporter *, YAResponseObject *);
@interface YAResponseObject : NSObject

- (id)initWithData:(NSArray *)data
	 callbackQueue:(dispatch_queue_t)callbackQueue
	 beginCallback:(YAResponseObjectCallback)beginCallback
	   endCallback:(YAResponseObjectCallback)endCallback;

- (id)initWithData:(NSArray *)data endCallback:(YAResponseObjectCallback)endCallback;

+ (instancetype)objectWithData:(NSArray *)data endCallback:(YAResponseObjectCallback)endCallback;

@property (nonatomic, strong, readonly) NSArray *data;

/**
* Called on import begin.
* Recommended specify before import start.
*/
@property (nonatomic, copy) YAResponseObjectCallback importBeginCallback;

/**
* Called on import end.
*/
@property (nonatomic, copy) YAResponseObjectCallback importEndCallback;

/**
* Default is main queue;
*/
@property (nonatomic, unsafe_unretained) dispatch_queue_t callbackQueue;

@end
