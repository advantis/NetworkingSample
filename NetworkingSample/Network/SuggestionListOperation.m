//
//  Copyright © 2013 Yuri Kotov
//

#import "SuggestionListOperation.h"
#import "NetworkClient.h"
#import "SuggestionParser.h"

@implementation SuggestionListOperation

+ (id) performOperationWithTerm:(NSString *)term handler:(SuggestionListHandler)handler
{
    NSDictionary *params = @{
        @"q"        : term,
        @"output"   : @"toolbar"
    };

    NetworkClient *networkClient = [NetworkClient sharedClient];
    NSURLRequest *request = [networkClient requestWithMethod:@"GET" path:@"search" parameters:params];
    SuggestionListOperation *operation = [[self alloc] initWithRequest:request];
    id success = !!handler ? ^(__unused AFHTTPRequestOperation *op, NSXMLParser *parser) {
        SuggestionParser *delegate = [SuggestionParser new];
        parser.delegate = delegate;
        if ([parser parse]) handler(delegate.suggestions);
    } : nil;
    [operation setCompletionBlockWithSuccess:success failure:nil];
    [networkClient enqueueHTTPRequestOperation:operation];
    return operation;
}

@end