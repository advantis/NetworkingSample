//
//  WNPhotosImporter.m
//  WhatNow
//
//  Created by Dmitriy Shemet on 23.10.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "WNPhotosImporter.h"
#import "WNResponseImporter+Protected.h"

#import "YASimpleParser.h"

#import "WNPhoto.h"

@interface WNPhotosImporter ()

- (void)setupPrefetchPredicateIfNeeded;
- (BOOL)canSetupPrefetchPredicate;

- (void)setupRemovalPredicateIfNeeded;
- (BOOL)canSetupRemovalPredicate;

@end

@implementation WNPhotosImporter

#pragma mark - Init

- (Class)importObjectsClass
{
    return [WNPhoto class];
}

#pragma mark - Private

- (void)setupPrefetchPredicateIfNeeded
{
	if (![self canSetupPrefetchPredicate]) return;

	NSArray *identifiers = [self.importData valueForKey:@"photo_id"];
	self.fetchPredicate = [NSPredicate predicateWithFormat:@"identifier IN $VALUES" vars:@{@"VALUES" : identifiers}];
}


- (BOOL)canSetupPrefetchPredicate
{
	return self.fetchPredicate == nil;
}


- (void)setupRemovalPredicateIfNeeded
{
	//asap: move to session identifier for removing.

	if (![self canSetupRemovalPredicate]) return;

	if ((self.policy & WNResponseImporterPolicyExcludingHard) == 0)
	{
		self.removalPredicate = [NSPredicate predicateWithFormat:@"check for removal"];
	}
}


- (BOOL)canSetupRemovalPredicate
{
	return (self.removalPredicate == nil && [self canRemoveObjects]);
}


- (void)willBeginImport
{
    [super willBeginImport];

	[self setupPrefetchPredicateIfNeeded];
	[self.objectsGenerator setPrefetchPredicate:self.fetchPredicate];

	[self setupRemovalPredicateIfNeeded];
	[self.objectsGenerator setRemovalPredicate:self.removalPredicate];
}

- (id)processEntryImport:(id)data
{
    YASimpleParser *parser = [YASimpleParser parserWithDictionary:data];
    
    NSNumber *identifier = [parser longLongForKey:@"photo_id"];
    WNPhoto *photo = [self.objectsGenerator objectWithIdentifier:identifier];

    // parse photo data

	return photo;
}

@end
