//
//  Copyright © 2013 Yuri Kotov
//

#import "ViewController.h"
#import "SignUpOperation.h"
#import "AFHTTPRequestOperation+Perform.h"
#import "SampleRequest.h"

@implementation ViewController

- (IBAction) signUp
{
    SignUpOperation *operation = [SignUpOperation new];

    operation.email = nil;
    operation.password = nil;
    operation.birthday = nil;
    operation.male = NO;

    [operation perform];
}

@end