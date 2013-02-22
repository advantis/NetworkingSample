//
//  NWProfile.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NWProfile : NSObject


#pragma mark Properties

// Stores reference on profile's on server identifier
@property (nonatomic, readonly, strong) NSString *identifier;

@property (nonatomic, readonly, strong) NSString *firstName;
@property (nonatomic, readonly, strong) NSString *lastName;
@property (nonatomic, readonly, strong) NSArray *playlists;

#pragma mark -


@end
