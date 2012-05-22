//
// MASAppCell.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASAppCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface MASAppCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation MASAppCell
@synthesize iconImageView;
@synthesize appNameLabel;
@synthesize stateLabel;
@synthesize versionLabel;

+ (MASAppCell *)cellForTableView:(UITableView *)aTableView {
    static NSString *cellID = @"MASAppCell";
    MASAppCell *cell = (MASAppCell *)[aTableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[[UINib nibWithNibName:@"MASAppCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.stateLabel.layer.cornerRadius = 9.0;
    }

    return cell;
}

- (void)setAppInfo:(NSDictionary *)appInfo {
    NSDictionary *appDict = [appInfo objectForKey:@"app_info"];
    NSDictionary *statusDict = [appInfo objectForKey:@"status"];
    NSString *state = [statusDict objectForKey:@"state"];
    
    self.appNameLabel.text = [appDict objectForKey:@"name"];
    self.versionLabel.text = [statusDict objectForKey:@"version"];
    self.stateLabel.text = [[@"  " stringByAppendingString:state] stringByAppendingString:@"  "];
    
    CGFloat stateWidth = [self.stateLabel.text sizeWithFont:self.stateLabel.font].width;
    CGRect frame = self.stateLabel.frame;
    frame.size.width = stateWidth;
    self.stateLabel.frame = frame;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[appDict objectForKey:@"icon_url"]]];

    self.stateLabel.textColor = [UIColor whiteColor];
    
    if ([state isEqualToString:@"in review"]) {
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.973 green:0.580 blue:0.024 alpha:1];
    } else if ([state rangeOfString:@"rejected"].location != NSNotFound || [state isEqualToString:@"missing screenshot"]) {
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.725 green:0.290 blue:0.282 alpha:1];
    } else if ([state isEqualToString:@"waiting for review"]) {
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.227 green:0.529 blue:0.678 alpha:1];
    } else if ([state isEqualToString:@"approved"] || [state isEqualToString:@"pending developer release"]) {
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.275 green:0.533 blue:0.278 alpha:1];
    } else {
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1];
    }
//    when "approved"
//    "label-success"
//    when "pending developer release"
//    "label-success"

}


@end