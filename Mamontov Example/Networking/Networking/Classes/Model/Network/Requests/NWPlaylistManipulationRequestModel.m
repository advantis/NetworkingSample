//
//  NWPlaylistManipulationRequestModel.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWPlaylistManipulationRequestModel.h"


#pragma mark Static

typedef enum _NWManipulationType {
    NWManipulationAddPlaylist,
    NWManipulationRemovePlaylist,
    NWManipulationAddTrack,
    NWManipulationRemoveTrack
} NWManipulationType;


#pragma mark - Private interface declaration

@interface NWPlaylistManipulationRequestModel ()


#pragma mark - Instance methods

- (id)initWithObject:(id)object manipulationType:(NWManipulationType)type;


@end


#pragma mark - Public interface implementation

@implementation NWPlaylistManipulationRequestModel


#pragma mark - Instance methods

- (id)initWithObject:(id)object manipulationType:(NWManipulationType)type {
    
    // Check whether initialisation successful or not
    if ((self = [super init])) {
        
        
    }
    
    
    return self;
}

#pragma mark -


@end
