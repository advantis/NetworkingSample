//
//  NWPlaylist.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NWPlaylist : NSObject


#pragma mark Properties

// Stores reference on playlist's identifier on server
// (it is unique for specific user)
@property (nonatomic, readonly, copy) NSString *identifier;

@property (nonatomic, readonly, strong) NSDate *lastRefreshDate;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSArray *songs;

#pragma mark -


@end
