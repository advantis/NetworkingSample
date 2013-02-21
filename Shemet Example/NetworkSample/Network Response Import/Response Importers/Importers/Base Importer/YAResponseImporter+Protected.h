//
//  YAModelImporter+Protected.h
//  
//
//  Created by Dima Shemet on 28.08.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "YAResponseImporter.h"

@interface YAResponseImporter (YAResponseImporterProtected)

@property (nonatomic, weak, readonly) YAResponseImporter *parentImporter;
@property (nonatomic, strong) NSMutableArray *processedObjects;
@property (nonatomic, strong, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, strong, readonly) NSArray *importData;

/**
* Should be used in future instead of importData
*/
@property (nonatomic, strong, readonly) YAResponseObject *responseObject;

- (void)willBeginImport;
- (void)willEndImport;
- (void)didEndImport;
- (id)processEntryImport:(id)data;

@end
