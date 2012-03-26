//
//  IDDecisionDetailVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionDetailVC.h"

@interface IDDecisionDetailVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem * discussionButton;

@end


@implementation IDDecisionDetailVC

@synthesize decision         = _decision;
@synthesize editMode         = _editMode;
@synthesize discussionButton = _discussionButton;

- (void)viewDidUnload {
    [self setDiscussionButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
