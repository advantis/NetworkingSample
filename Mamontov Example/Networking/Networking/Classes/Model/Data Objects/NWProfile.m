//
//  NWProfile.m
//  Networking
//
//  Created by Sergey Mamontov on 2/22/13.
//  Copyright (c) 2013 Sergey Mamontov. All rights reserved.
//

#import "NWProfile.h"


#pragma mak Static

typedef enum _NWProfileFullNameElements {
    NWProfileFirstName,
    NWProfileLastName
} NWProfileFullNameElements;

struct NWProfileResponseDataKeysStruct {
    
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *identifier;
};

static struct NWProfileResponseDataKeysStruct NWProfileResponseDataKeys = {
    
    .name = @"name",
    .identifier = @"name"
};


#pragma mark - Private interface declaration

@interface NWProfile ()


#pragma mark - Properties

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSArray *playlists;


@end


#pragma mark - Public interface methods

@implementation NWProfile


#pragma mark - Instance methods

- (id)initWithData:(NSDictionary *)data {
    
    // Check whether intialisation was successful or not
    if ((self = [super init])) {
        
        NSArray *nameComponents = [[data valueForKey:NWProfileResponseDataKeys.name] componentsSeparatedByString:@"."];
        self.firstName = [nameComponents objectAtIndex:NWProfileFirstName];
        self.lastName = [nameComponents objectAtIndex:NWProfileLastName];
        self.identifier = [data valueForKey:NWProfileResponseDataKeys.identifier];
    }
    
    
    return self;
}

- (NSString *)debugDescription {
    
    return [NSString stringWithFormat:@"%@(%p) {\n\tidentifier: %@\n\tfirst name: %@\n\tlast name: %@\n\tplaylists: %@\n}",
            NSStringFromClass([self class]),
            self, self.identifier,
            self.firstName,
            self.lastName,
            self.playlists];
}

#pragma mark -


@end
