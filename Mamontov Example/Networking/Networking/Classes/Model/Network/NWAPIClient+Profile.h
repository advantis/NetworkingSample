//
//  NWAPIClient+Profile.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAPIClient.h"
#import "NWStrucutreAndTypes.h"


@interface NWAPIClient (Profile)


#pragma mark Instance methods

#pragma mark - Authorisation

- (void)authoriseWithUsername:(NSString *)username
                     password:(NSString *)password
               successHanlder:(NWAuthorisationCompletionBlock)successBlock
                 errorHandler:(void(^)(NSError *))errorBlock;


#pragma mark - Playlists manipulation

- (void)addPlaylistWithName:(NSString *)playlistName
             successHandler:(NWPlaylistAddCompletionBlock)succeccBlock
               errorHandler:(void(^)(NSError *))errorBlock;

#pragma mark -


@end
