//
// MASLoginViewController.m
// My App Status
//
// Created by Brian Cooke on 5/22/12.
// Copyright (c) 2012 roobasoft, LLC. All rights reserved.
//

#import "MASLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MASLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation MASLoginViewController
@synthesize emailField;
@synthesize passwordField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title                  = @"Login";
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.emailField becomeFirstResponder];
    
    self.loginButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.cornerRadius = 5.0;
}


- (void)viewDidUnload {
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return IS_IPAD || interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - helpers
- (void)showFailWhale {
    [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Email and password didn't match a known user. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - actions
- (IBAction)login:(id)sender {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if ([self.emailField.text length] == 0 || [self.passwordField.text length] == 0) {
        [self showFailWhale];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MASHTTPClient sharedInstance] loginWithEmail:self.emailField.text andPassword:self.passwordField.text withCompletionBlock:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMASDidLoginNotification object:nil];
            [self dismissModalViewControllerAnimated:YES];
        } else {
            [self showFailWhale];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self.passwordField resignFirstResponder];
        [self login:nil];
    }
    return YES;
}

@end