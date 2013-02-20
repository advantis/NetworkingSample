

#import <Foundation/Foundation.h>
#import "WNPhoto.h"

@class WNPhotoResponse;

@interface WNPhoto (WNImport)

+ (void)importPhotosResponse:(id)response asInitial:(BOOL)asInitial callback:(void (^)(BOOL, NSArray *))callback;


@end