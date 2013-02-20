
#import "YAResponseImporter.h"

typedef enum
{
    WNResponseImporterPolicyDefault = 0 << 0,	// may create objects if needed.
    WNResponseImporterPolicyPassive = 1 << 0,	// can only fetch objects, can't create
    WNResponseImporterPolicyExcluding = 1 << 1,	// can remove objects from db
	WNResponseImporterPolicyExcludingHard = 2 << 1, // custom for project.
} WNResponseImporterPolicy;

@interface WNPhotoResponseImporter : YAResponseImporter

/**
* Policy affects on how objects will be created, could they be deleted and so on.
*/
@property (nonatomic) WNResponseImporterPolicy policy;

@property (nonatomic, readonly) BOOL canRemoveObjects;
@property (nonatomic, readonly) BOOL canCreateObjects;

@end