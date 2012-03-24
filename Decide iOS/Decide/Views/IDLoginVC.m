//
//  IDLoginVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDLoginVC.h"

@interface IDLoginVC ()

@property (strong, nonatomic) IBOutlet UITextField * usernameField;
@property (strong, nonatomic) IBOutlet UITextField * passwordField;
@property (strong, nonatomic) IBOutlet UIButton * loginButton;

@end

@implementation IDLoginVC

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton   = _loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
