//
// MASMasterViewController.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASMasterViewController.h"
#import "MASDetailViewController.h"
#import "MBProgressHUD.h"
#import "MASServerController.h"
#import "MASLoginViewController.h"

@interface MASMasterViewController ()
@property (strong, nonatomic) NSArray *apps;
@end

@implementation MASMasterViewController
@synthesize apps                 = _apps;
@synthesize detailViewController = _detailViewController;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = NSLocalizedString(@"Your Apps", @"Your Apps");

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover     = CGSizeMake(320.0, 600.0);
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAppsFromServer) name:kMASDidLoginNotification object:nil];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadAppsFromServer];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    } else {
        return YES;
    }
}


#pragma mark - helpers
- (void)downloadAppsFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[MASServerController sharedInstance] loadAppsWithCompletionBlock:^(kMASLoadAppsResponseCodes response, NSArray * appInfo) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         switch (response) {
             case kMASLoadAppsResponseSuccess:
                 self.apps = appInfo;
                 [self.tableView reloadData];
                 break;

             case kMASLoadAppsResponseAuthenticationFailed:{
                 MASLoginViewController *vc = [[MASLoginViewController alloc] init];
                 UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                 nc.modalPresentationStyle = UIModalPresentationFormSheet;
                 [self presentModalViewController:nc animated:YES];
                 break;
             }

             case kMASLoadAppsResponseFailed:
                 // handle network error
                 [[[UIAlertView alloc] initWithTitle:@"Unable to Load Apps" message:@"Failed to refresh your apps. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                 break;
         }

         if (response == kMASLoadAppsResponseSuccess) {
             return;
         }
     }
    ];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.apps count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AppsCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    NSDictionary *appInfo = [self.apps objectAtIndex:indexPath.row];
    cell.textLabel.text = [[appInfo objectForKey:@"app_info"] objectForKey:@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
// NSDate *object = [_objects objectAtIndex:indexPath.row];
//
// if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
// if (!self.detailViewController) {
// self.detailViewController = [[MASDetailViewController alloc] initWithNibName:@"MASDetailViewController_iPhone" bundle:nil];
// }
//
// self.detailViewController.detailItem = object;
// [self.navigationController pushViewController:self.detailViewController animated:YES];
// } else {
// self.detailViewController.detailItem = object;
// }
}


@end