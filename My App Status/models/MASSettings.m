//
// MASSettings.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASSettings.h"
#import "SFHFKeychainUtils.h"
#import "CWLSynthesizeSingleton.h"

#define USERDEFAULTS    ([NSUserDefaults standardUserDefaults])

@implementation MASSettings

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(MASSettings)
+ (MASSettings *)sharedInstance {
    return [MASSettings sharedMASSettings];
}


- (NSString *)genRandStringLength:(int)len {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];

    for (int i = 0; i < len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }

    return randomString;
}


- (NSString *)keyForKeychainKey:(NSString *)aKey {
    if ([USERDEFAULTS objectForKey:@"KeychainKey"] == nil) {
        [USERDEFAULTS setObject:[self genRandStringLength:8] forKey:@"KeychainKey"];
        [USERDEFAULTS synchronize];
    }

    return [[USERDEFAULTS objectForKey:@"KeychainKey"] stringByAppendingFormat:@"-%@", aKey];
}


- (void)setAuthToken:(NSString *)authToken {
    NSError *error = nil;

    [SFHFKeychainUtils storeUsername:[self keyForKeychainKey:@"auth_token"] andPassword:authToken forServiceName:@"MAS" updateExisting:YES error:&error];
}


- (NSString *)authToken {
    NSError *error = nil;

    return [SFHFKeychainUtils getPasswordForUsername:[self keyForKeychainKey:@"auth_token"] andServiceName:@"MAS" error:&error];
}


@end