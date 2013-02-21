//
//  WNResponseImporter.m
//  WhatNow
//
//  Created by Dmitriy Shemet on 23.10.12.
//  Copyright (c) 2012 Yalantis. All rights reserved.
//

#import "WNResponseImporter.h"
#import "WNResponseImporter+Protected.h"

@interface WNResponseImporter ()

@property (nonatomic, strong) WNObjectsGenerator *objectsGenerator;

@end

@implementation WNResponseImporter

@end

@implementation WNResponseImporter (WNResponseImporterProtected)

@dynamic objectsGenerator;

#pragma mark - Overriden API

- (void)willBeginImport
{
    [super willBeginImport];
    
    self.objectsGenerator = [WNObjectsGenerator generatorWithObjectsClass:[self importObjectsClass]
                                                                   policy:[self objectsGeneratorPolicy]];
    [self.objectsGenerator setDelegate:self];
    [self.objectsGenerator setContext:self.importContext];
}

- (void)willEndImport
{
    [super willEndImport];

	[self.objectsGenerator save];
    self.objectsGenerator = nil;
}

#pragma mark - Subclassing API

- (Class)importObjectsClass
{
    return nil;
}

#pragma mark - Properties

- (BOOL)canCreateObjects
{
	return (self.policy & WNResponseImporterPolicyPassive) == 0;
}

- (BOOL)canRemoveObjects
{
	return (self.policy & (WNResponseImporterPolicyExcluding | WNResponseImporterPolicyExcludingHard)) > 0;
}

#pragma mark - WNObjectsGeneratorDelegate API

- (WNObjectsGeneratorPolicy)objectsGeneratorPolicy
{
	WNObjectsGeneratorPolicy result = WNObjectsGeneratorPolicyDefault;

	if (![self canCreateObjects])
	{
		result |= WNObjectsGeneratorPolicyPassive;
	}

	if ([self canRemoveObjects])
	{
		result |= WNObjectsGeneratorPolicyExcluding;
	}

	return result;
}

@end
