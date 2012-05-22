//
//  MASAppCell.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASAppCell : UITableViewCell

+ (MASAppCell *)cellForTableView:(UITableView *)aTableView;
- (void)setAppInfo:(NSDictionary *)appInfo;

@end
