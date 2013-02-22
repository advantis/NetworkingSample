//
//  NWResponseParserProtocol.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NWResponseParserProtocol <NSObject>


@required

- (id)parseData:(id)response;

#pragma mark -


@end
