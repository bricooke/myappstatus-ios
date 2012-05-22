//
// MASServerController.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASServerController.h"


static NSString *const kMASAPIBaseURLString = @"https://myappstat.us/api/";


@implementation MASServerController

+ (MASServerController *)sharedInstance {
    static MASServerController *secrets = nil;
    static dispatch_once_t      onceToken;

    dispatch_once(
        &onceToken, ^{
            secrets = [[MASServerController alloc] initWithBaseURL:[NSURL URLWithString:kMASAPIBaseURLString]];
        }
        );

    return secrets;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];

    if (!self) {
        return nil;
    }

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];

    return self;
}


- (void)loginWithEmail:(NSString *)anEmail andPassword:(NSString *)aPassword withCompletionBlock:(MASServerLoginCB)completionBlock {
    [self setAuthorizationHeaderWithUsername:anEmail password:aPassword];

    [self getPath:@"auth_tokens" parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
         [self clearAuthorizationHeader];
         MAS_SETTINGS.authToken = [responseObject objectForKey:@"token"];
     }
          failure:^(AFHTTPRequestOperation * operation, NSError * error) {
         completionBlock (NO);
     }
    ];
}

@end