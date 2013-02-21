//
//  WNResponseImporter+Protected.h
//  WhatNow
//
//  Created by Dmitriy Shemet on 23.10.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "WNResponseImporter.h"
#import "YAResponseImporter+Protected.h"

#import "WNNetworkConstants.h"

#import "WNObjectsGenerator.h"

@interface WNResponseImporter (WNResponseImporterProtected) <WNObjectsGeneratorDelegate>

@property (nonatomic, strong, readonly) WNObjectsGenerator *objectsGenerator;

- (Class)importObjectsClass;
- (WNObjectsGeneratorPolicy)objectsGeneratorPolicy;

@end
