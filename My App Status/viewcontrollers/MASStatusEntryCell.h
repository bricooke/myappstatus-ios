//
//  MASStatusEntryCell.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASStatusEntryCell : UITableViewCell

+ (MASStatusEntryCell *)cellForTableView:(UITableView *)aTableView;
- (void) setStatusEntry:(NSDictionary *)aStatusEntry;

@end
