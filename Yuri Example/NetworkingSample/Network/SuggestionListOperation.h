//
//  Copyright © 2013 Yuri Kotov
//

#import "AFNetworking.h"

typedef void(^SuggestionListHandler)(NSArray *suggestions);

@interface SuggestionListOperation : AFXMLRequestOperation

+ (id) performOperationWithTerm:(NSString *)term handler:(SuggestionListHandler)handler;

@end