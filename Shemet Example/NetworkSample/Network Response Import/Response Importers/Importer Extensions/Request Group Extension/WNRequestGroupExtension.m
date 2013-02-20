//
// Created by dmitriy on 14.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WNRequestGroupExtension.h"

#import "CDRequestGroup.h"
#import "CDRequestSegment.h"
#import "CDRequestPair.h"

#import "WNObjectsGenerator.h"
#import "WNPhotoResponseImporter.h"
#import "WNPhoto.h"

@interface WNRequestGroupExtension ()

@property (nonatomic, strong) CDRequestGroup *group;
@property (nonatomic, strong) NSNumber *segmentIdentifier;
@property (nonatomic, strong) CDRequestSegment *segment;

@property (nonatomic) NSInteger pairOrder;

- (void)initializeImportVars;

@property (nonatomic, strong) WNObjectsGenerator *pairsGenerator;
- (void)initializePairsGenerator;

@end

@implementation WNRequestGroupExtension

#pragma mark - Init

- (id)initWithGroup:(CDRequestGroup *)group segmentIdentifier:(NSNumber *)segmentIdentifier
{
	NSAssert(group != nil, @"Group for extension can't be nil!", self);
	NSAssert(segmentIdentifier != nil, @"Segment identifier for extension can't be nil", nil);

	self = [super init];
	if (self != nil)
	{
		[self setGroup:group];
		[self setSegmentIdentifier:segmentIdentifier];
	}

	return self;
}

+ (instancetype)extensionForGroup:(CDRequestGroup *)group segmentIdentifier:(NSNumber *)segmentIdentifier;
{
	return [[self alloc] initWithGroup:group segmentIdentifier:segmentIdentifier];
}

#pragma mark - Private

- (void)initializePairsGenerator
{
	NSParameterAssert(self.segment != nil);

	self.pairsGenerator = [WNObjectsGenerator generatorWithObjectsClass:[CDRequestPair class]
																 policy:WNObjectsGeneratorPolicyDefault];
	[self.pairsGenerator setContext:self.importContext];
}

- (void)initializeImportVars
{
	self.group = [self.group existingEntityInContext:self.importContext];
	self.segment = [self.group segmentWithIdentifier:self.segmentIdentifier createIfNeeded:YES];

	[self.group setLastUpdatedSegment:self.segment];

	self.pairOrder = [self.segment.lastPairOrder integerValue];
}

#pragma mark - Import

- (void)importWillBegin
{
	[super importWillBegin];

	self.group = [self.group existingEntityInContext:self.importContext];
	if ([(WNPhotoResponseImporter *) self.importer canRemoveObjects])
	{
		// to prevent trip on disk
		[[self.group existingEntityInContext:[self.importContext newNestedContext]] invalidateSegmentsCache];
		NSParameterAssert(self.group.segments.count == 0);
	}

	[self initializeImportVars];

	[self initializePairsGenerator];
}

- (void)importWillEnd
{
	[self.segment setLastPairOrder:@(self.pairOrder)];

	self.pairOrder = 0;
	self.pairsGenerator = nil;
	self.segment = nil;

	[[self.group existingEntityInContext:[self.importContext newNestedContext]] invalidateUnusedGroups];

	[super importWillEnd];
}

- (void)processEntry:(NSManagedObject *)entry fromData:(id)data
{
	CDRequestPair *pair = [self.pairsGenerator generateObject];
	[pair setOrder:@(++self.pairOrder)];
	[pair setGroupIdentifier:self.group.identifier];
	[pair setSegment:self.segment];
	[pair setPhoto:(id)entry];
}

@end