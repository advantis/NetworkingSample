
#import "WNPhotoResponseImporter.h"
#import "YAResponseImporter+Protected.h"

#import "WNObjectsGenerator.h"
#import "YASimpleParser.h"
#import "WNPhoto.h"

@interface WNPhotoResponseImporter ()

@property (nonatomic, strong) WNObjectsGenerator *objectsGenerator;

@end

@implementation WNPhotoResponseImporter

#pragma mark - Private

- (void)setupPrefetchPredicate
{
	// get by KVC array of primary keys.
	NSArray *identifiers = [self.importData valueForKey:@"photo_identifier"];

	[self.objectsGenerator setPrefetchPredicate:[NSPredicate predicateWithFormat:@"primaryKey IN $IDENTIFIERS"
																			vars:@{@"IDENTIFIERS" : identifiers}]];
}

- (void)setupRemovalPredicate
{
	if ((self.policy & WNResponseImporterPolicyExcludingHard) == 0)
	{
		[self.objectsGenerator setRemovalPredicate:[NSPredicate predicateWithFormat:@"some check for removal"]];
	}
}

#pragma mark - Import

- (void)willBeginImport
{
	[super willBeginImport];

	self.objectsGenerator = [WNObjectsGenerator generatorWithObjectsClass:[WNPhoto class]
																   policy:[self objectsGeneratorPolicy]];
	[self.objectsGenerator setDelegate:self];
	[self.objectsGenerator setContext:self.importContext];

	[self setupPrefetchPredicate];
	[self setupRemovalPredicate];
}

- (void)willEndImport
{
	[super willEndImport];

	[self.objectsGenerator save];
	self.objectsGenerator = nil;
}

- (id)processEntryImport:(id)data
{
	YASimpleParser *parser = [YASimpleParser parserWithDictionary:data];

	// getting primary key from server response.
	NSNumber *identifier = [parser longLongForKey:@"photo_identifier"];

	// retrieving photo by primary key from prefetched data (so, no duplicates & trips to db in loop)
	WNPhoto *photo = [self.objectsGenerator objectWithIdentifier:identifier];

	// parse photo entity somehow by parser

	return photo;
}

#pragma mark - Properties

- (BOOL)canCreateObjects
{
	return (self.policy & WNResponseImporterPolicyPassive) == 0;
}

- (BOOL)canRemoveObjects
{
	return (self.policy & (WNResponseImporterPolicyExcluding | WNResponseImporterPolicyExcludingHard)) > 0;
}

#pragma mark - WNObjectsGeneratorDelegate API

- (WNObjectsGeneratorPolicy)objectsGeneratorPolicy
{
	WNObjectsGeneratorPolicy result = WNObjectsGeneratorPolicyDefault;

	if (![self canCreateObjects])
	{
		result |= WNObjectsGeneratorPolicyPassive;
	}

	if ([self canRemoveObjects])
	{
		result |= WNObjectsGeneratorPolicyExcluding;
	}

	return result;
}


@end
