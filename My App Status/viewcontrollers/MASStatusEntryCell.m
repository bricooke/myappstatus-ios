//
// MASStatusEntryCell.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASStatusEntryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor_MASAdditions.h"
#import "TTTTimeIntervalFormatter.h"

@interface MASStatusEntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

static TTTTimeIntervalFormatter * timeFormatter;
static NSDateFormatter *dateFormatter;

@implementation MASStatusEntryCell
@synthesize stateLabel;
@synthesize versionLabel;
@synthesize timeLabel;

+ (void)initialize {
    static dispatch_once_t onceToken;

    dispatch_once(
        &onceToken, ^{
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
        }
        );
}


+ (MASStatusEntryCell *)cellForTableView:(UITableView *)aTableView {
    static NSString    *cellID = @"MASStatusEntryCell";
    MASStatusEntryCell *cell   = (MASStatusEntryCell *)[aTableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell                               = [[[UINib nibWithNibName:@"MASStatusEntryCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.stateLabel.layer.cornerRadius = 9.0;
    }

    return cell;
}


- (NSString *)timeInThisState:(id)time {
    if ([time isKindOfClass:[NSString class]]) {
        return [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[dateFormatter dateFromString:[time stringByReplacingOccurrencesOfString:@"Z" withString:@"GMT"]]];
    } else {
        return [[timeFormatter stringForTimeInterval:0 - [time doubleValue]] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
    }
}


- (void)setStatusEntry:(NSDictionary *)aStatusEntry {
    NSString *state = [aStatusEntry objectForKey:@"state"];
    
    if ([state isEqualToString:@"pending developer release"]) {
        state = @"pending release";
    }
    
    self.stateLabel.text            = [[@"  " stringByAppendingString:state] stringByAppendingString:@"  "];
    self.stateLabel.backgroundColor = [UIColor MASColorForState:[aStatusEntry objectForKey:@"state"]];

    CGFloat stateWidth = [self.stateLabel.text sizeWithFont:self.stateLabel.font].width;
    CGRect  frame      = self.stateLabel.frame;
    frame.size.width      = stateWidth;
    self.stateLabel.frame = frame;

    self.versionLabel.text = [aStatusEntry objectForKey:@"version"];
    self.timeLabel.text    = [self timeInThisState:[aStatusEntry objectForKey:@"time_in_this_state"]];
}


@end