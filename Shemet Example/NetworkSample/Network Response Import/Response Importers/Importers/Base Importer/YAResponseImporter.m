
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


#import "YAResponseImporter+Protected.h"

@interface YAResponseImporter ()

@property (nonatomic, strong) NSManagedObjectContext *importContext;
@property (nonatomic, strong) NSArray *importData;
@property (nonatomic, strong) NSMutableArray *processedObjectIDs;
@property (nonatomic, strong) NSMutableArray *processedObjects;

@property (nonatomic) BOOL importing;

@property (nonatomic, weak) YAResponseImporter *parentImporter;
@property (nonatomic, unsafe_unretained) dispatch_queue_t callbackQueue;
@property (nonatomic, copy) void (^callbackBlock)(id importer);

- (void)performImportSync;
- (void)performImportAsync;

@property (nonatomic, strong) NSMutableSet *registeredExtensions;

- (void)extensionsWillBeginImport;
- (void)extensionsWillEndImport;
- (void)extensionsDidEndImport;
- (void)extensionsProcessEntry:(NSManagedObject *)entity fromData:(id)data;

@end

@implementation YAResponseImporter

@synthesize processedObjectIDs = _objectIDs;
@synthesize parentImporter = _parentImporter;
@synthesize callbackBlock = _callbackBlock;
@synthesize callbackQueue = _callbackQueue;
@synthesize importContext = _importContext;
@synthesize importData = _importData;

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

- (void)setCallbackQueue:(dispatch_queue_t)callbackQueue
{
    if (_callbackQueue != nil)
    {
        dispatch_release(_callbackQueue);
        _callbackQueue = nil;
    }
    
    if (callbackQueue != nil)
    {
        dispatch_retain(callbackQueue);
        _callbackQueue = callbackQueue;
    }
}

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

- (void)performImportSync
{
    [self willBeginImport];
    
    for (id data in self.importData)
    {
        @autoreleasepool
        {
            NSManagedObject *entry = [self processEntryImport:data];
			if (entry != nil)
			{
				[self.processedObjects addObject:entry];
			}

			[self extensionsProcessEntry:entry fromData:data];
        }
    }
    
    [self willEndImport];

    [self didEndImport];
    
    [(NSMutableArray *)self.processedObjectIDs addObjectsFromArray:[self.processedObjects valueForKey:@"objectID"]];
    
    self.importContext = nil;
}

- (void)performImportAsync
{
    [self.importContext performBlock:^
    {
        @autoreleasepool
        {
            [self performImportSync];
            
            dispatch_sync(self.callbackQueue, ^
            {
                self.callbackBlock(self);
            });
            self.callbackQueue = nil;
            self.callbackBlock = nil;
        }
    }];
}

#pragma mark - Public API

- (void)importData:(NSArray *)data
{
	NSParameterAssert(data != nil);
    self.importData = data;
    self.callbackBlock = nil;
    self.callbackQueue = nil;
    
    [self performImportSync];
}

- (void)importData:(NSArray *)data completionBlock:(void (^)(id))block
{
    NSParameterAssert(block != nil);
    
    self.importData = data;
    self.callbackBlock = block;
    self.callbackQueue = dispatch_get_main_queue();
    
    [self performImportAsync];
}

@end

@implementation YAResponseImporter (YAResponseImporterProtected)

@dynamic processedObjects;
@dynamic importContext;
@dynamic importData;
@dynamic parentImporter;

#pragma mark - Protected API

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