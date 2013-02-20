//
// Created by dmitriy on 20.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ViewController.h"
#import "WNPhoto.h"

@interface ViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@end

@implementation ViewController

- (void)requestInitialPhotos
{
	[WNPhoto fetchPhotosWithOffset:0 asInitial:YES onSuccess:^(NSArray *array)
	{
		// nothing to do, because NSFRC handle all data for us.

	} onFailure:^(NSError *error)
	{
		//show error
	}];
}

- (void)requestMorePhotos
{
	NSUInteger offset = 100; // [self.resultsController totalObjectsCount]

	[WNPhoto fetchPhotosWithOffset:offset asInitial:YES onSuccess:^(NSArray *array)
	{
		// nothing to do, because NSFRC handle all data for us.

	} onFailure:^(NSError *error)
	{
		//show error
	}];
}

#pragma mark - NSFethedResultsControllerDelegate

// handle NSFRC callbacks to update tableView.

@end