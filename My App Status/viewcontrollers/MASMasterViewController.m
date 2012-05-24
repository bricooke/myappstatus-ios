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
#import "MASHTTPClient.h"
#import "MASLoginViewController.h"
#import "MASAppCell.h"

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.apps count] == 0) {
        [self downloadAppsFromServer];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    } else {
        return YES;
    }
}

#pragma mark - actions
- (void) refresh:(id)sender {
    [self downloadAppsFromServer];
}


#pragma mark - helpers
- (void)downloadAppsFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[MASHTTPClient sharedInstance] loadAppsWithCompletionBlock:^(kMASLoadResponseCodes response, NSArray * appInfo) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.apps count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MASAppCell *cell = [MASAppCell cellForTableView:tableView];

    [cell setAppInfo:[self.apps objectAtIndex:indexPath.row]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *appInfo = [self.apps objectAtIndex:indexPath.row];


    if (!self.detailViewController) {
        self.detailViewController = [[MASDetailViewController alloc] init];
    }

    self.detailViewController.appInfo = [appInfo objectForKey:@"app_info"];

    if (IS_IPHONE) {
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}


@end