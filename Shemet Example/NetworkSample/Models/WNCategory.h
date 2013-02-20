
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WNPhoto;

@interface WNCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;
@end

@interface WNCategory (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(WNPhoto *)value;
- (void)removePhotosObject:(WNPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end