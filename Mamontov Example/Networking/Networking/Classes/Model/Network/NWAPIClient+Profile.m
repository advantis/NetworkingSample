//
//  NWAPIClient+Profile.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAPIClient+Profile.h"
#import "NWAuthoriseRequestModel.h"


#pragma mark 

@implementation NWAPIClient (Profile)


#pragma mark Instance methods

- (void)authoriseWithUsername:(NSString *)username
                     password:(NSString *)password
               successHanlder:(NWAuthorisationCompletionBlock)successBlock
                 errorHandler:(void(^)(NSError *))errorBlock {
    
    [self performRequest:[NWAuthoriseRequestModel authoriseModelWithUsername:username andPassword:password]
      withSuccessHandler:successBlock
            errorHandler:errorBlock];
}


#pragma mark - Playlists manipulation

- (void)addPlaylistWithName:(NSString *)playlistName
             successHandler:(NWPlaylistAddCompletionBlock)succeccBlock
               errorHandler:(void(^)(NSError *))errorBlock {
    
}

#pragma mark -


@end
