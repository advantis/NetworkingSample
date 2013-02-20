//
//  Copyright © 2013 Yuri Kotov
//

#import <UIKit/UIKit.h>

@interface SuggestionParser : NSObject <NSXMLParserDelegate>

@property (readonly, nonatomic) NSArray *suggestions;

@end