//
//  Copyright © 2013 Yuri Kotov
//

#import "AFNetworking.h"

@interface SignUpOperation : AFJSONRequestOperation

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic, getter=isMale) BOOL male;

@end