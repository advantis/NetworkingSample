

#import "WNCategoryListExtension.h"

#import "WNObjectsGenerator.h"
#import "WNCategory.h"
#import "WNPhoto.h"

#import "YASimpleParser.h"

@interface WNCategoryListExtension ()

@property (nonatomic, strong) WNObjectsGenerator *categoriesGenerator;

@end

@implementation WNCategoryListExtension

#pragma mark - Import

- (void)importWillBegin
{
	[super importWillBegin];

	self.categoriesGenerator = [WNObjectsGenerator generatorWithObjectsClass:[WNCategory class]
																	  policy:WNObjectsGeneratorPolicyPassive];
	self.categoriesGenerator.context = self.importContext;
	NSArray *categoryIdentifiers = [self.importData valueForKeyPath:@"category.category_identifier"];
	self.categoriesGenerator.prefetchPredicate = [NSPredicate predicateWithFormat:@"identifier IN $IDENTIFIERS"
																			 vars:@{@"IDENTIFIERS" : categoryIdentifiers}];
}

- (void)importWillEnd
{
	[super importWillEnd];

	self.categoriesGenerator = nil;
}

- (void)processEntry:(NSManagedObject *)entry fromData:(id)data
{
	WNPhoto *photo = (WNPhoto *)entry;

	NSDictionary *categoryData = [data objectForKey:@"category"];
	YASimpleParser *categoriesParser = [YASimpleParser parserWithDictionary:categoryData];

	if (categoriesParser != nil)
	{
		NSNumber *categoryIdentifier = [categoriesParser longLongForKey:@"category_identifier"];
		[photo setCategory:[self.categoriesGenerator objectWithIdentifier:categoryIdentifier]];

		NSAssert(photo.category != nil, @"Category can't be nil:\nResponse:\n%@", data);
	}
}

@end