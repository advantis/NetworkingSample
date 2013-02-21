//
//  YAModelImporter.h
//  
//
//  Created by Dima Shemet on 28.08.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YAResponseObject.h"

@interface YAResponseImporter : NSObject
{
    @protected
    NSManagedObjectContext *_importContext;
}

@property (nonatomic, strong, readonly) NSArray *processedObjectIDs;

- (id)initWithParentImporter:(YAResponseImporter *)parentImporter;
+ (id)importerWithParentImporter:(YAResponseImporter *)parentImporter;

- (void)importData:(NSArray *)data __deprecated;
- (void)importData:(NSArray *)data completionBlock:(void (^)(id importer))block __deprecated;

- (void)importResponseObjectSync:(YAResponseObject *)object;
- (void)importResponseObjectAsync:(YAResponseObject *)object;

@property (nonatomic, readonly, getter=isImporting) BOOL importing;

/**
*
*/
@property (nonatomic, strong, readonly) NSSet *extensions;
- (void)addExtensions:(NSSet *)extensions;
- (void)removeExtensions:(NSSet *)extensions;

@end

#pragma mark - Importer Extension

@interface YAImporterExtension : NSObject

@property (nonatomic, weak, readonly) YAResponseImporter *importer;
@property (nonatomic, weak, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, weak, readonly) id importData;

- (void)importWillBegin;
- (void)importWillEnd;
- (void)importDidEnd;

- (void)processEntry:(NSManagedObject *)entry fromData:(id)data;

@end;
