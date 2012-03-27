//
//  IDDecisionDetailVC.m
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionDetailVC.h"
#import "Decision+Extras.h"
#import "IDDecisionDetailCell.h"

@interface IDDecisionDetailVC ()

@property (nonatomic, strong) IBOutlet UIBarButtonItem * discussionButton;

@end


@implementation IDDecisionDetailVC

@synthesize decision         = _decision;
@synthesize editMode         = _editMode;
@synthesize discussionButton = _discussionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert([self decision], @"No decision.");
}

- (void)viewDidUnload {
    [self setDiscussionButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self decision] options] count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDDecisionDetailCell * cell = nil;
    BOOL inEditMode = [self isInEditMode];
    Decision * decision = [self decision];
    
    if (inEditMode) {
        if (indexPath.row == 0)
            cell = [tableView dequeueReusableCellWithIdentifier:@"IDNewDecisionCell"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"IDNewOptionCell"];
    }
    else {
        if (indexPath.row == 0)
            cell = [tableView dequeueReusableCellWithIdentifier:@"IDDecisionDescriptionCell"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"IDOptionDescriptionCell"];
    }
    
    if (indexPath.row == 0) {
        [cell setupWithDecision:[self decision] editMode:inEditMode];
    }
    else {
        Option * option = nil;
        NSInteger index = indexPath.row - 1;
        
        if (indexPath.row - 1 < [[decision options] count])
            option = [[decision options] objectAtIndex:index];
        
        [cell setupWithOption:option editMode:inEditMode];
    }
    
    return cell;
}

@end
