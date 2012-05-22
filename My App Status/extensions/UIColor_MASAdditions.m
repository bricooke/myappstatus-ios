//
//  UIColor_MASAdditions.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation UIColor (MASAdditions)

+ (UIColor *)MASColorForState:(NSString *)state {
    if ([state isEqualToString:@"in review"]) {
        return [UIColor colorWithRed:0.973 green:0.580 blue:0.024 alpha:1];
    } else if ([state rangeOfString:@"rejected"].location != NSNotFound || [state isEqualToString:@"missing screenshot"]) {
        return [UIColor colorWithRed:0.725 green:0.290 blue:0.282 alpha:1];
    } else if ([state isEqualToString:@"waiting for review"]) {
        return [UIColor colorWithRed:0.227 green:0.529 blue:0.678 alpha:1];
    } else if ([state isEqualToString:@"approved"] || [state isEqualToString:@"pending developer release"]) {
        return [UIColor colorWithRed:0.275 green:0.533 blue:0.278 alpha:1];
    } else {
        return [UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1];
    }
}

@end
