
#import "WNPhoto+WNPrimaryImport.h"
#import "WNCategoryCounterImporter.h"
#import "YASimpleParser.h"
#import "WNUserStorage.h"
#import "WNNetworkConstants.h"
#import "WNPhotosImporter.h"
#import "WNPhotoResponseImporter.h"
#import "WNCategoryListExtension.h"

@implementation WNPhoto (WNImport)

+ (void)importFilterPhotosResponse:(id)response asInitial:(BOOL)asInitial callback:(void (^)(BOOL, NSArray *))callback
{
	NSParameterAssert(callback != nil);

	YASimpleParser *parser = [YASimpleParser parserWithDictionary:response];

	NSArray *photos = [parser arrayForKey:@"photos"];

	WNPhotoResponseImporter *importer = [WNPhotoResponseImporter new];
	// initial means, that all other photos (not processed in this response, but, probably
	// related to this response, will be removed.
	// in real application this rule (to which response photos related) by relationship.

	[importer setPolicy:asInitial ? WNResponseImporterPolicyExcluding : WNResponseImporterPolicyDefault];

	// extension give us flexibility in import.
	// ie. in real app on top of this importer i can also import categories, if i wish, set photo venue,
	// build order index and so on.
	NSSet *extensions = [[NSSet alloc] initWithObjects:
		[WNCategoryListExtension new],
		// other possible extensions
		nil];
	[importer addExtensions:extensions];

	[importer importData:photos completionBlock:^(id instance)
	{
		callback(YES, [(YAResponseImporter *)instance processedObjectIDs]);
	}];
}

@end