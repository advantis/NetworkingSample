//
//  Copyright © 2013 Yuri Kotov
//

#import "SuggestionListViewController.h"
#import "SuggestionListOperation.h"

@interface SuggestionListViewController ()
@property (strong, nonatomic) NSArray *suggestions;
@end

@implementation SuggestionListViewController
{
    __weak SuggestionListOperation *_operation;
}

#pragma mark - SuggestionListViewController
- (void) searchForTerm:(NSString *)term
{
    __weak typeof(self) controller = self;
    SuggestionListHandler handler = ^(NSArray *suggestions) {
        controller.suggestions = suggestions;
        [controller.tableView reloadData];
    };
    _operation = [SuggestionListOperation performOperationWithTerm:term handler:handler];
}

#pragma mark - UIViewController
- (void) viewDidDisappear:(BOOL)animated
{
    [_operation cancel];
    [super viewDidDisappear:animated];
}

#pragma mark - UISearchBarDelegate
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchForTerm:searchBar.text];
    [searchBar endEditing:NO];
}

@end