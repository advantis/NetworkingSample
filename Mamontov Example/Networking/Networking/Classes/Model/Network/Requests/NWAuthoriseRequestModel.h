//
//  NWAuthoriseRequestModel.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseRequestModel.h"


@interface NWAuthoriseRequestModel : NWBaseRequestModel


#pragma mark Class methods

+ (instancetype)authoriseModelWithUsername:(NSString *)username andPassword:(NSString *)password;

#pragma mark -


@end
