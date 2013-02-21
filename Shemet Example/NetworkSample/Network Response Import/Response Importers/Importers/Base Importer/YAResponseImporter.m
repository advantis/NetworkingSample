//
//  YAModelImporter.m
//  
//
//  Created by Dima Shemet on 28.08.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "YAResponseImporter.h"
#import "NSException+YAAdditions.h"

@interface YAImporterExtension ()

@property (nonatomic, weak) YAResponseImporter *importer;
@property (nonatomic, weak) NSManagedObjectContext *importContext;
@property (nonatomic, weak) id importData;

- (void)importWillBeginWithSender:(YAResponseImporter *)sender
					   importData:(id)importData
						inContext:(NSManagedObjectContext *)ctx;

@end

@implementation YAImporterExtension

- (void)importWillBeginWithSender:(YAResponseImporter *)sender
					   importData:(id)importData
						inContext:(NSManagedObjectContext *)ctx
{
	[self setImporter:sender];
	[self setImportContext:ctx];
	[self setImportData:importData];

	[self importWillBegin];
}

- (void)importWillBegin
{}

- (void)importWillEnd
{
	[self setImporter:nil];
	[self setImportContext:nil];
	[self setImportData:nil];
}

- (void)importDidEnd
{}

- (void)processEntry:(NSManagedObject *)entry fromData:(id)data
{
	NSString *reason = [NSString stringWithFormat:@"Subclassing error for: %@", NSStringFromSelector(_cmd)];
	[[NSException exceptionForInstance:self reason:reason] raise];
}

@end

#pragma mark - Response Importer Part

#import "YAResponseImporter+Protected.h"

@interface YAResponseImporter ()

@property (nonatomic) BOOL importing;

- (void)importResponseObjectSync:(YAResponseObject *)object;
- (void)importResponseObjectAsync:(YAResponseObject *)object;


@property (nonatomic, weak) YAResponseImporter *parentImporter;

@property (nonatomic, strong) NSMutableSet *registeredExtensions;

@property (nonatomic, strong) NSManagedObjectContext *importContext;
@property (nonatomic, strong) NSMutableArray *processedObjectIDs;
@property (nonatomic, strong) NSMutableArray *processedObjects;

@property (nonatomic, strong) YAResponseObject *responseObject;


- (void)extensionsWillBeginImport;
- (void)extensionsWillEndImport;
- (void)extensionsDidEndImport;
- (void)extensionsProcessEntry:(NSManagedObject *)entity fromData:(id)data;

@end

@implementation YAResponseImporter

@synthesize importContext = _importContext;

#pragma mark - Init API

- (id)init
{
    self = [super init];
    if (self)
    {
        self.processedObjectIDs = [NSMutableArray array];
        self.processedObjects = [NSMutableArray array];
		self.registeredExtensions = [NSMutableSet setWithCapacity:1];
    }
    return self;
}

- (id)initWithParentImporter:(YAResponseImporter *)parentImporter
{    
    self = [self init];
    if (self)
    {
        self.parentImporter = parentImporter;
    }
    
    return self;
}

+ (id)importerWithParentImporter:(YAResponseImporter *)parentImporter
{
    return [[self alloc] initWithParentImporter:parentImporter];
}

#pragma mark - Properties API

- (NSManagedObjectContext *)importContext
{
    if (_importContext == nil)
    {
        if (self.parentImporter != nil)
        {
            _importContext = [self.parentImporter.importContext newNestedContext];
        }
        else
        {
            _importContext = [NSManagedObjectContext importContext];
        }
    }
    return _importContext;
}

#pragma mark - Extensions

- (NSSet *)extensions
{
	return self.registeredExtensions;
}

- (void)extensionsWillBeginImport
{
	//todo: profile, maybe can add dispatch_group + wait
	for (YAImporterExtension *extension in self.registeredExtensions)
	{
		[extension importWillBeginWithSender:self importData:self.importData inContext:self.importContext];
	}
}

- (void)extensionsWillEndImport
{
	for (YAImporterExtension *extension in self.registeredExtensions)
	{
		[extension importWillEnd];
	}
}

- (void)extensionsDidEndImport
{
	for (YAImporterExtension *extension in self.registeredExtensions)
	{
		[extension importDidEnd];
	}
}

- (void)extensionsProcessEntry:(NSManagedObject *)entity fromData:(id)data
{
	for (YAImporterExtension *extension in self.registeredExtensions)
	{
		[extension processEntry:entity fromData:data];
	}
}

- (void)addExtensions:(NSSet *)extensions
{
	NSAssert(![self isImporting], @"Modifying of extensions during import is not permitted", nil);

	[self.registeredExtensions unionSet:extensions];
}

- (void)removeExtensions:(NSSet *)extensions
{
	NSAssert(![self isImporting], @"Modifying of extensions during import is not permitted", nil);

	[self.registeredExtensions minusSet:extensions];
}

#pragma mark - Private API

- (void)importResponseObjectSync:(YAResponseObject *)object
{
	self.responseObject = object;

	[self willBeginImport];

	for (id dataEntry in self.importData)
	{
		@autoreleasepool
		{
			NSManagedObject *entry = [self processEntryImport:dataEntry];
			if (entry != nil)
			{
				[self.processedObjects addObject:entry];
			}

			[self extensionsProcessEntry:entry fromData:dataEntry];
		}
	}

	[self willEndImport];

	[self didEndImport];

	[(NSMutableArray *)self.processedObjectIDs addObjectsFromArray:[self.processedObjects valueForKey:@"objectID"]];

	self.responseObject = nil;
	self.importContext = nil;
}

- (void)importResponseObjectAsync:(YAResponseObject *)object
{
	[self.importContext performBlock:^
	{
		@autoreleasepool
		{
			dispatch_queue_t callbackQueue = object.callbackQueue != nil ? object.callbackQueue :
																		dispatch_get_main_queue();
			dispatch_retain(callbackQueue);

			if (object.importBeginCallback != nil)
			{
				dispatch_sync(callbackQueue, ^
				{
					object.importBeginCallback(self, object);
				});
			}

			[self importResponseObjectSync:object];

			if (object.importEndCallback != nil)
			{
				dispatch_async(callbackQueue, ^
				{
					object.importEndCallback(self, object);
				});
			}

			dispatch_release(callbackQueue);
		}
	}];
}

#pragma mark - Public API

- (void)importData:(NSArray *)data
{
	NSParameterAssert(data != nil);

	[self importResponseObjectSync:[[YAResponseObject alloc] initWithData:data endCallback:nil]];
}

- (void)importData:(NSArray *)data completionBlock:(void (^)(id))block
{
	YAResponseObjectCallback callback = nil;
	if (block != nil)
	{
		callback = ^(YAResponseImporter *importer, YAResponseObject *responseObject)
		{
			block(importer);
		};
	}

	[self importResponseObjectAsync:[[YAResponseObject alloc] initWithData:data endCallback:callback]];
}

@end

@implementation YAResponseImporter (YAResponseImporterProtected)

@dynamic processedObjects;
@dynamic importContext;
@dynamic importData;
@dynamic parentImporter;
@dynamic responseObject;

#pragma mark - Protected API

- (NSArray *)importData
{
	return self.responseObject.data;
}

- (id)processEntryImport:(id)data
{
    [NSException raise:@"Subcalssing error: you should override this method" format:nil];
    return nil;
}

- (void)willBeginImport
{
	[self setImporting:YES];

    [(NSMutableArray *)self.processedObjectIDs removeAllObjects];

	[self extensionsWillBeginImport];
}

- (void)willEndImport
{
	[self extensionsWillEndImport];

	if (self.parentImporter == nil)
	{
		[self.importContext save];
	}
}

- (void)didEndImport
{
	[self extensionsDidEndImport];

	[self setImporting:NO];
}

@end