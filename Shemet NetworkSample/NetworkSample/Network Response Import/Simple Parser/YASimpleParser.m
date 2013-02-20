
#import "YASimpleParser.h"
#import "NSDateFormatter+YAAdditions.h"
#import "WNNetworkConstants.h"

@interface YASimpleParser ()

@property (nonatomic, strong) NSDictionary *dataObject;

- (id)notNullObjectForKey:(NSString *)key;

@end

@implementation YASimpleParser

@synthesize dataObject = _dataObject;

#pragma mark - Init API

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary != nil);
    self = [super init];
    if (self)
    {
        self.dataObject = dictionary;
    }
    
    return self;
}

+ (id)parserWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary == nil) return nil;

	if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    
    return [[self alloc] initWithDictionary:dictionary];
}

#pragma mark - Private API

- (id)notNullObjectForKey:(NSString *)key
{
    id object = [self.dataObject objectForKey:key];
//    NSAssert(object != nil, @"Invalid lookup key: %@\nAvailable Keys: %@", key, [self.dataObject allKeys]);
    
    return [object isKindOfClass:[NSNull class]] ? nil : object;
}

#pragma mark - Public API

- (NSString *)stringForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    
    return nil;
}

- (NSURL *)urlForKey:(NSString *)key
{
	return [[NSURL alloc] initWithString:[self stringForKey:key]];
}

- (NSNumber *)integerForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithInteger:[object integerValue]];
    }

    return nil;
}

- (NSNumber *)longLongForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithLongLong:[object longLongValue]];
    }
    
    return nil;
}

- (NSNumber *)floatForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithFloat:[object floatValue]];
    }

    return nil;
}

- (NSNumber *)doubleForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithDouble:[object doubleValue]];
    }

    return nil;
}

- (NSNumber *)boolForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithBool:[object boolValue]];
    }
    
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)key
{
    id object = [self notNullObjectForKey:key];
    return ([object isKindOfClass:[NSArray class]]) ? object : nil;
}

- (NSDate *)dateForKey:(NSString *)key
{
    NSString *dateString = [self stringForKey:key];
    if (dateString == nil) return nil;
    
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithFormat:WNNetworkDateFormat];
    return [formatter dateFromString:dateString];
}

- (id)objectForKey:(NSString *)key
{
    return [self.dataObject objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [self notNullObjectForKey:key];
}

@end
