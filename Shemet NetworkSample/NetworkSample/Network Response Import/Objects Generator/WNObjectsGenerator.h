#import <Foundation/Foundation.h>

typedef enum
{
    WNObjectsGeneratorPolicyDefault = 0 << 0,    // update/create model, save as default
    WNObjectsGeneratorPolicyPassive = 1 << 0,   // don't create object, if not presented in store.
    WNObjectsGeneratorPolicyExcluding = 1 << 1,    // update/create model, delete not updated, but existed, save
} WNObjectsGeneratorPolicy;

@class WNObjectsGenerator;
@protocol WNObjectsGeneratorDelegate <NSObject>
@optional
- (void)generator:(WNObjectsGenerator *)generator willRemoveObjects:(NSArray *)objects;
- (BOOL)generator:(WNObjectsGenerator *)generator shouldRemoveObject:(NSManagedObject *)object;

@end

static NSString * const WNObjectsGeneratorDefaultIdentifierKey = @"identifier";

@interface WNObjectsGenerator : NSObject

/**
* Subclass of NSManagedObject for creation & fetching.
*/
@property (nonatomic, readonly) Class objectsClass;

@property (nonatomic, readonly) WNObjectsGeneratorPolicy policy;

@property (nonatomic, strong) NSManagedObjectContext *context;

/**
* Filtering, which objects should be deleted.
* If nil, then all objects in database (excluding updated/created) will be deleted.
*/
@property (nonatomic, strong) NSPredicate *removalPredicate;

/**
* Specify objects for prefetching. Typically you should pass array with Primary Keys.
* Uniqueness guaranteed within this predicate.
*/
@property (nonatomic, strong) NSPredicate *prefetchPredicate;

@property (nonatomic, weak) id <WNObjectsGeneratorDelegate> delegate;

+ (id)generatorWithObjectsClass:(Class)objectsClass policy:(WNObjectsGeneratorPolicy)policy;
- (id)initWithObjectsClass:(Class)objectsClass policy:(WNObjectsGeneratorPolicy)policy;
- (id)initWithObjectsClass:(Class)objectsClass policy:(WNObjectsGeneratorPolicy)policy identifierKey:(NSString *)key;

/**
* This method create instance for specified class and don't care about uniqueness at all.
* Be careful, because it lead duplication if not handled properly
*/
- (id)generateObject;

/**
* This method create instance for specified class if policy allows & object not exists.
* Identifier typically is a primary key by which you identify any object;
*/
- (id)objectWithIdentifier:(id)identifier;

/**
* Same as above. On insert invokes block (ie. on creation)
*/
- (id)objectWithIdentifier:(id)identifier onInsert:(void (^)(WNObjectsGenerator *generator, id object))onInsert;

- (void)save;

@end
