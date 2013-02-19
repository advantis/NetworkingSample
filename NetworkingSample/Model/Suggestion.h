//
//  Copyright © 2013 Yuri Kotov
//

#import <UIKit/UIKit.h>

@interface Suggestion : NSObject

@property (strong, nonatomic) NSString *query;
@property (nonatomic) NSUInteger occurrences;

@end