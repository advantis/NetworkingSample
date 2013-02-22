//
//  NWStrucutreAndTypes.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#pragma mark Class forward

@class NWProfile, NWPlaylist;

struct NWResourceMIMETypeStruct {
    
    __unsafe_unretained NSString *JSON;
};

static struct NWResourceMIMETypeStruct NWResourceMIMEType = {
    
    .JSON = @"application/json"
};

typedef void(^NWRequestComletionBlock)(id);
typedef void(^NWAuthorisationCompletionBlock)(NWProfile *);
typedef void(^NWPlaylistAddCompletionBlock)(NWPlaylist *);
