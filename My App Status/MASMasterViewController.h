//
//  MASMasterViewController.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MASDetailViewController;

@interface MASMasterViewController : UITableViewController

@property (strong, nonatomic) MASDetailViewController *detailViewController;

@end
