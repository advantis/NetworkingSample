
#import <Foundation/Foundation.h>

@interface YAResponseImporter : NSObject
{
    @protected
    NSManagedObjectContext *_importContext;
    NSArray *_importData;
}

@property (nonatomic, strong, readonly) NSArray *processedObjectIDs;

- (id)initWithParentImporter:(YAResponseImporter *)parentImporter;
+ (id)importerWithParentImporter:(YAResponseImporter *)parentImporter;

- (void)importData:(NSArray *)data;
- (void)importData:(NSArray *)data completionBlock:(void (^)(id importer))block;

@property (nonatomic, readonly, getter=isImporting) BOOL importing;

/**
*
*/
@property (nonatomic, strong, readonly) NSSet *extensions;
- (void)addExtensions:(NSSet *)extensions;
- (void)removeExtensions:(NSSet *)extensions;

@end

@interface YAImporterExtension : NSObject

@property (nonatomic, weak, readonly) YAResponseImporter *importer;
@property (nonatomic, weak, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, weak, readonly) id importData;

- (void)importWillBegin;
- (void)importWillEnd;
- (void)importDidEnd;

- (void)processEntry:(NSManagedObject *)entry fromData:(id)data;

@end;
