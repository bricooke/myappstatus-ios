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
#import "UIColor_MASAdditions.h"

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
    self.stateLabel.backgroundColor = [UIColor MASColorForState:state];
}


@end