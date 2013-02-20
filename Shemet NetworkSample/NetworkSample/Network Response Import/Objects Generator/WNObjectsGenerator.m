
#import "WNObjectsGenerator.h"

@interface WNObjectsGenerator ()
{
    struct
    {
        NSUInteger delegateRespondsShouldRemoveObject : 1;
        NSUInteger delegateRespondsWillRemoveObjects : 1;
    } _flags;
}

@property (nonatomic, copy) NSString *identifierKey;
@property (nonatomic, strong) NSMutableSet *existingObjects;
@property (nonatomic, strong) NSMutableSet *processedObjects;

- (void)performRemovalIfNeeded;

- (void)setupDelegateFlags;

@end

@implementation WNObjectsGenerator

#pragma mark - Init API

- (id)initWithObjectsClass:(Class)objectsClass policy:(WNObjectsGeneratorPolicy)policy identifierKey:(NSString *)key
{
    NSParameterAssert([objectsClass isSubclassOfClass:[NSManagedObject class]]);
    self = [super init];
    if (self)
    {
        _policy = policy;
        _objectsClass = objectsClass;
        self.processedObjects = [NSMutableSet set];
        self.identifierKey = key;
    }
    
    return self;    
}

- (id)initWithObjectsClass:(Class)objectsClass policy:(WNObjectsGeneratorPolicy)policy
{
    return [self initWithObjectsClass:objectsClass policy:policy identifierKey:WNObjectsGeneratorDefaultIdentifierKey];
}

+ (id)generatorWithObjectsClass:(Class)modelClass policy:(WNObjectsGeneratorPolicy)policy
{
    return [[self alloc] initWithObjectsClass:modelClass policy:policy];
}

#pragma mark - Private API

- (void)setupDelegateFlags
{
    _flags.delegateRespondsWillRemoveObjects = [self.delegate
                                                respondsToSelector:@selector(generator:willRemoveObjects:)];
    _flags.delegateRespondsShouldRemoveObject = [self.delegate
                                                 respondsToSelector:@selector(generator:shouldRemoveObject:)];
}

- (void)performRemovalIfNeeded
{
    BOOL canRemoveObjects = (self.policy & WNObjectsGeneratorPolicyExcluding) == WNObjectsGeneratorPolicyExcluding;
    if (!canRemoveObjects) return;
    
    NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:2];
    [predicates addObject:[NSPredicate predicateWithFormat:@"NOT (self IN %@)", self.processedObjects]];
    if (self.removalPredicate != nil)
    {
        [predicates addObject:self.removalPredicate];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    NSArray *objectsToRemove = [self.objectsClass entitiesByPredicate:predicate
															   sorted:nil inContext:self.context];
    if (objectsToRemove.count == 0) return;
    
    if (_flags.delegateRespondsWillRemoveObjects)
    {
        [self.delegate generator:self willRemoveObjects:objectsToRemove];
    }
    
    for (NSManagedObject *obj in objectsToRemove)
    {
        BOOL shouldDelete = YES;
        if (_flags.delegateRespondsShouldRemoveObject)
        {
            shouldDelete = [self.delegate generator:self shouldRemoveObject:obj];
        }
        
        if (shouldDelete)
        {
            [self.context deleteObject:obj];
        }
    }
}

#pragma mark - Properties API

- (NSMutableSet *)existingObjects
{
    if (_existingObjects != nil) return _existingObjects;
    
    NSArray *objects = nil;
    if (self.prefetchPredicate != nil)
    {
		NSFetchRequest *fetchRequest = [self.objectsClass fetchRequestWithPredicate:self.prefetchPredicate];

        objects = [self.context executeFetchRequest:fetchRequest];
	}
    else
    {
        objects = [NSArray array];
    }
    
    _existingObjects = [NSMutableSet setWithArray:objects];
    
    return _existingObjects;
}

- (void)setDelegate:(id<WNObjectsGeneratorDelegate>)delegate
{
    if (_delegate == delegate) return;
    
    _delegate = delegate;
    
    [self setupDelegateFlags];
}

#pragma mark - Public API

- (id)generateObject
{
	id object = [self.objectsClass insertEntityInContext:self.context];
	[self.existingObjects addObject:object];

	return object;
}

- (id)objectWithIdentifier:(id)identifier
{
    return [self objectWithIdentifier:identifier onInsert:nil];
}

- (id)objectWithIdentifier:(id)identifier onInsert:(void (^)(WNObjectsGenerator *generator, id object))onInsert
{
    id existingModel = [self.existingObjects objectWhereValueForKey:self.identifierKey equalTo:identifier];
    
    BOOL canInsertObjects = (self.policy & WNObjectsGeneratorPolicyPassive) != WNObjectsGeneratorPolicyPassive;
    if (existingModel == nil && canInsertObjects)
    {
		existingModel = [self generateObject];

        [existingModel setValue:identifier forKey:self.identifierKey];

        if (onInsert != nil) onInsert(self, existingModel);
    }
    
    if (existingModel != nil)
    {
        [self.processedObjects addObject:existingModel];
    }
    
    return existingModel;
}

- (void)save
{
    [self performRemovalIfNeeded];
    
    [self.context save];
}

@end
