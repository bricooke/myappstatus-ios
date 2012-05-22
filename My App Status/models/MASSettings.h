//
//  MASSettings.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAS_SETTINGS ([MASSettings sharedInstance])

@interface MASSettings : NSObject

+ (MASSettings *)sharedMASSettings;
+ (MASSettings *)sharedInstance;

@property (assign) NSString *authToken;

@end
