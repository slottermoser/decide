//
//  IDDecisionsVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionsVC.h"

@interface IDDecisionsVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem * logoutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * addButton;

@end

@implementation IDDecisionsVC

@synthesize logoutButton = _logoutButton;
@synthesize addButton    = _addButton;

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
    [self setLogoutButton:nil];
    [self setAddButton:nil];
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
