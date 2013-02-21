//
//  WNPhotosImporter.h
//  WhatNow
//
//  Created by Dmitriy Shemet on 23.10.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "WNResponseImporter.h"

@interface WNPhotosImporter : WNResponseImporter

/* This predicate may be used to prefetch possible values from db.
 * Used once before parser start.
 */
@property (nonatomic, strong) NSPredicate *fetchPredicate;

/* This predicate may be used to limit bounds of removal fetch. Especially, if
 * Used if policy is Excluding & once before parser starts
 */
@property (nonatomic, strong) NSPredicate *removalPredicate;

@end
