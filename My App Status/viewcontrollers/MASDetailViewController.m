//
// MASDetailViewController.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASDetailViewController.h"
#import "MASStatusEntryCell.h"

@interface MASDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSArray             *statusEntries;
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@end

@implementation MASDetailViewController
@synthesize tableView               = _tableView;
@synthesize statusEntries           = _statusEntries;
@synthesize appInfo                 = _appInfo;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setAppInfo:(NSDictionary *)newAppInfo {
    if (_appInfo != newAppInfo) {
        _appInfo = newAppInfo;
        self.statusEntries = nil;
        
        self.title = [newAppInfo objectForKey:@"name"];
        
        [self.tableView reloadData];
        
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


- (void)configureView {
    // make sure we can show a spinner.
    if (self.view == nil) {
        return;
    }
    
    if (self.appInfo) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [[MASHTTPClient sharedInstance] loadStatusesForAppId:[[self.appInfo objectForKey:@"id"] integerValue] withCompletionBlock:^(kMASLoadResponseCodes response, NSArray * statusEntries) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (response == kMASLoadAppsResponseSuccess) {
             self.statusEntries = statusEntries;

             [self.tableView reloadData];
            }
         }
        ];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (IS_IPHONE) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    } else {
        return YES;
    }
}


- (id)init {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        self.title = NSLocalizedString(@"", @"");
    }

    return self;
}


#pragma mark - Split view
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}


#pragma mark - tableview datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.statusEntries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MASStatusEntryCell *cell = [MASStatusEntryCell cellForTableView:tableView];
    [cell setStatusEntry:[self.statusEntries objectAtIndex:indexPath.row]];
    return cell;
}



@end