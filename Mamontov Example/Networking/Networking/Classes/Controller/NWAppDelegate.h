//
//  NWAppDelegate.h
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark Class forward

@class NWAuthorisationViewController;


@interface NWAppDelegate : UIResponder <UIApplicationDelegate>


#pragma mark - Properties

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NWAuthorisationViewController *viewController;

#pragma mark -


@end
