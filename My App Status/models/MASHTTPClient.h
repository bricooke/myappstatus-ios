//
//  MASServerController.h
//  My App Status
//
//  Created by Brian Cooke on 5/22/12.
//  Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CWLSynthesizeSingleton.h"

extern NSString *const kMASDidLoginNotification;

typedef enum {
    kMASLoadAppsResponseAuthenticationFailed,
    kMASLoadAppsResponseFailed,
    kMASLoadAppsResponseSuccess
} kMASLoadResponseCodes;

typedef void(^MASServerLoginCB)(BOOL success);
typedef void(^MASServerLoadAppsCB)(kMASLoadResponseCodes response, NSArray *appInfo);
typedef void(^MASServerLoadStatusEntriesCB)(kMASLoadResponseCodes response, NSArray *statusEntries);

@interface MASHTTPClient : AFHTTPClient

+ (MASHTTPClient *)sharedInstance;

- (void) loginWithEmail:(NSString *)anEmail andPassword:(NSString *)aPassword withCompletionBlock:(MASServerLoginCB)completionBlock;
- (void) loadAppsWithCompletionBlock:(MASServerLoadAppsCB)completionBlock;
- (void) loadStatusesForAppId:(NSUInteger)appId withCompletionBlock:(MASServerLoadStatusEntriesCB)completionBlock;

@end
