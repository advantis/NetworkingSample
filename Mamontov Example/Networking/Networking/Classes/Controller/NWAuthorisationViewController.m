//
//  NWAuthorisationViewController.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWAuthorisationViewController.h"
#import "NWAPIClient+Profile.h"
#import "NWProfile.h"


#pragma mark Private interface declaration

@interface NWAuthorisationViewController ()


#pragma mark - Properties

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;


#pragma mark - Instance methods

#pragma mark - Handler methods

- (void)handleAuthoriseButtonTapped:(id)sender;
- (void)handleAuthorisationSuccess:(NWProfile *)profile;
- (void)handleAuthorisationError:(NSError *)error;


@end


#pragma mark - Public interface implementation

@implementation NWAuthorisationViewController


#pragma mark - Instance methods

- (void)viewDidAppear:(BOOL)animated {
    
    // Forward to the super class
    [super viewDidAppear:animated];
    
    [self handleAuthoriseButtonTapped:nil];
}


#pragma mark - Handler methods

- (void)handleAuthoriseButtonTapped:(id)sender {
    
    // (Validate user input)
    
    // Continue if user input is valid
    __block __weak NWAuthorisationViewController *weakSelf = self;
    [[NWAPIClient sharedInstance] authoriseWithUsername:self.usernameField.text?self.usernameField.text:nil
                                               password:self.passwordField.text?self.passwordField.text:nil
                                         successHanlder:^(NWProfile *profile) {
                                             
                                             [weakSelf handleAuthorisationSuccess:profile];
                                         }
                                           errorHandler:^(NSError *authorisationError) {
                                               
                                               [weakSelf handleAuthorisationError:authorisationError];
                                           }];
}

- (void)handleAuthorisationSuccess:(NWProfile *)profile {
    
#ifdef DEBUG
    NSLog(@"AUTHORISIED USER: %@", [profile debugDescription]);
#endif
    
    if ([[profile playlists] count] == 0) {
        
        // Create new playlist
    }
    else {
        
        // Pull out list of tracks for first playlist
    }
}

- (void)handleAuthorisationError:(NSError *)error {
    
    // Handle authorisation error
#ifdef DEBUG
    NSLog(@"AUTHORISATION FAILED BECAUSE OF ERROR: %@", error);
#endif
}


#pragma mark -


@end
