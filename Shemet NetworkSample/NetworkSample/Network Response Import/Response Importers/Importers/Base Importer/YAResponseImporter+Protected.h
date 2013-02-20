
#import "YAResponseImporter.h"

@interface YAResponseImporter (YAResponseImporterProtected)

@property (nonatomic, weak, readonly) YAResponseImporter *parentImporter;
@property (nonatomic, strong) NSMutableArray *processedObjects;
@property (nonatomic, strong, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, strong, readonly) NSArray *importData;

- (void)willBeginImport;
- (void)willEndImport;
- (void)didEndImport;
- (id)processEntryImport:(id)data;

@end
