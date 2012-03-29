//
//  IDLoginVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDLoginVC.h"
#import "IDLoginManager.h"

@interface IDLoginVC ()

@property (strong, nonatomic) IBOutlet UITextField * usernameField;
@property (strong, nonatomic) IBOutlet UITextField * passwordField;
@property (strong, nonatomic) IBOutlet UIButton * loginButton;
@property (strong, nonatomic) IBOutlet UILabel * errorLabel;

@end


@implementation IDLoginVC

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton   = _loginButton;
@synthesize errorLabel    = _errorLabel;

- (void)viewDidLoad {
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
}

- (void)setErrorText:(NSString *)text {
    
    UILabel * label = [self errorLabel];
    
    if (!text) {
        [label setText:@""];
        [label setHidden:YES];
    }
    else {
        [label setText:text];
        [label setHidden:NO];
    }
}

- (IBAction)login:(id)sender {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    
    [[IDLoginManager defaultManager] loginWithUsername:[[self usernameField] text]
                                              password:[[self passwordField] text]
                                                 block:
     ^(NSString * errMsg, NSError * error) {
         
         if (error) {
             [self setErrorText:[error localizedDescription]];
         }
         else {
             [self setErrorText:nil];
             [self performSegueWithIdentifier:@"IDLoginSegue"
                                       sender:self];
         }
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == [self usernameField]) {
        [[self passwordField] becomeFirstResponder];
        return NO;
    }
    else if (textField == [self passwordField]) {
        [[self passwordField] resignFirstResponder];
        [self login:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

@end
