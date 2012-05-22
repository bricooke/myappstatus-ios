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

typedef void(^MASServerLoginCB)(BOOL success);

@interface MASServerController : AFHTTPClient

+ (MASServerController *)sharedInstance;

- (void) loginWithEmail:(NSString *)anEmail andPassword:(NSString *)aPassword withCompletionBlock:(MASServerLoginCB)completionBlock;

@end
