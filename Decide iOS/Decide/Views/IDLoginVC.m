//
//  IDLoginVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDLoginVC.h"
#import "IDHTTPRequest.h"

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
    
    IDHTTPRequest * request = [IDHTTPRequest new];
    [request loginWithUsername:[[self usernameField] text]
                      password:[[self passwordField] text]
                         block:
     ^(NSString * errMsg, NSError * error) {
         
         if (errMsg) {
             [self setErrorText:errMsg];
         }
         else if (error) {
             [self setErrorText:[error localizedDescription]];
         }
         else {
             [self setErrorText:nil];
             [self performSegueWithIdentifier:@"IDLoginSegue"
                                       sender:self];
         }
     }];
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
