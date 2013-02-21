//
//  WNResponseImporter.h
//  WhatNow
//
//  Created by Dmitriy Shemet on 23.10.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "YAResponseImporter.h"

typedef enum
{
    WNResponseImporterPolicyDefault = 0 << 0,
    WNResponseImporterPolicyPassive = 1 << 0,
    WNResponseImporterPolicyExcluding = 1 << 1,
	WNResponseImporterPolicyExcludingHard = 2 << 1,
} WNResponseImporterPolicy;

@interface WNResponseImporter : YAResponseImporter

/* Policy affects on how objects will be created, could they be deleted and so on.
 */
@property (nonatomic) WNResponseImporterPolicy policy;

@property (nonatomic, readonly) BOOL canRemoveObjects;
@property (nonatomic, readonly) BOOL canCreateObjects;

@end