//
//  IDDecisionsVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionsVC.h"
#import "IDDecisionDetailVC.h"
#import "Decision+Extras.h"
#import "IDDecisionCell.h"

@interface IDDecisionsVC ()

@property (nonatomic, strong) IBOutlet UIBarButtonItem * logoutButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * addButton;

@end


@implementation IDDecisionsVC

@synthesize logoutButton = _logoutButton;
@synthesize addButton    = _addButton;

- (void)viewDidLoad {
    
    // TODO: Set up table view.
    
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setLogoutButton:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
}

- (IBAction)logout:(id)sender {
    
    // !!!: I'm not sending a logout request to the web app just to keep things simple. 
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    IDDecisionDetailVC * vc = [segue destinationViewController];
    Decision * decision = nil;
    
    if (sender == [self addButton]) {
        decision = [Decision createDecisionInContext:[vc moc]];
        [vc setEditMode:YES];
    }
    else if ([sender isKindOfClass:[IDDecisionCell class]]) {
        decision = [sender decision];
    }
    else
        NSAssert(NO, @"Unknown sender!");
    
    [vc setDecision:decision];
}

@end
