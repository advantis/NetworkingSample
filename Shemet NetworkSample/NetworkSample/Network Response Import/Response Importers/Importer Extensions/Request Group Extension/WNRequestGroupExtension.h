//
// Created by dmitriy on 14.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YAResponseImporter.h"

/**
* This extension handle pairs creation for new photos within specified group.
*/

@class CDRequestGroup;

@interface WNRequestGroupExtension : YAImporterExtension

- (id)initWithGroup:(CDRequestGroup *)group segmentIdentifier:(NSNumber *)segmentIdentifier;
+ (instancetype)extensionForGroup:(CDRequestGroup *)group segmentIdentifier:(NSNumber *)segmentIdentifier;

@property (nonatomic, strong, readonly) CDRequestGroup *group;
@property (nonatomic, strong, readonly) NSNumber *segmentIdentifier;

@end