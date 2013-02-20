

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WNCategory;

@interface WNPhoto : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) WNCategory *category;

@end

@interface WNPhoto (CoreDataGeneratedAccessors)
@end

#import "WNPhoto+WNNetwork.h"
#import "WNPhoto+WNPrimaryImport.h"