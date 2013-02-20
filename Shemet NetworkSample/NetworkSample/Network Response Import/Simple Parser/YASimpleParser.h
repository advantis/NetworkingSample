
#import <Foundation/Foundation.h>

@interface YASimpleParser : NSObject

+ (id)parserWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)stringForKey:(NSString *)key;
- (NSURL *)urlForKey:(NSString *)key;
- (NSNumber *)integerForKey:(NSString *)key;
- (NSNumber *)longLongForKey:(NSString *)key;
- (NSNumber *)floatForKey:(NSString *)key;
- (NSNumber *)doubleForKey:(NSString *)key;
- (NSNumber *)boolForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

@end
