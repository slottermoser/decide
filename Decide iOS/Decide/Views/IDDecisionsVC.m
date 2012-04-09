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
#import "User+Extras.h"
#import "IDDecisionCell.h"
#import "RBReporter.h"
#import "IDLoginManager.h"
#import "IDHTTPRequest.h"

@interface IDDecisionsVC ()

@property (nonatomic, strong) IBOutlet UIBarButtonItem * logoutButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * addButton;
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, copy) NSArray * decisions;

@end


@implementation IDDecisionsVC

@synthesize logoutButton = _logoutButton;
@synthesize addButton    = _addButton;
@synthesize tableView    = _tableView;
@synthesize decisions    = _decisions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User * user = [[IDLoginManager defaultManager] currentUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Decision class])];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user == %@", user]];
    
    NSError * error = nil;
    NSArray * results = [[self moc] executeFetchRequest:request error:&error];
    
    [RBReporter logError:error];
    
    if (results)
        [self setDecisions:results];
    
    [[IDHTTPRequest new] decisionsWithBlock:^(id response, NSError * error) {
        
        if (error) {
            [RBReporter logError:error];
        }
        else {
            
            if ([response count] == 0)
                return;
            
            NSManagedObjectContext * moc = [[response objectAtIndex:0] managedObjectContext];
            
            if (![moc save:&error]) {
                [RBReporter logError:error];
                return;
            }
            
            // Grabs all the decisions from the server. 
            NSMutableArray * newDecisions = [NSMutableArray arrayWithCapacity:[response count]];
            
            // Loads the Decisions into this view's MOC.
            for (Decision * decision in response)
                [newDecisions addObject:[decision loadIntoMOC:[self moc]]];
            
            [self setDecisions:newDecisions];
            [[self tableView] reloadData];
        }
    }];
}

- (void)viewDidUnload {
    [self setLogoutButton:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
}

- (IBAction)logout:(id)sender {

//    [[IDHTTPRequest new] upvoteOptionWithID:2 block:^(id response, NSError * error) {
//        NSLog(@"ERROR: %@", error);
//    }];
    
    
    
//    [[IDHTTPRequest new] decisionWithID:1
//                                  block:^(id response, NSError * error) {
//                                      NSLog(@"ERROR: %@", error);
//                                  }];
    
    
    IDHTTPRequest * request = [IDHTTPRequest new];
    [request logoutBlock:^(id response, NSError * error) {
        // Pops the view regardless of the result of the logout, for simplicity.
        [[self navigationController] popViewControllerAnimated:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id vc = nil;
    Decision * decision = nil;
    
    if (sender == [self addButton]) {
        vc = [[segue destinationViewController] topViewController];
        NSManagedObjectContext * moc = [vc moc];
        User * user = [[[IDLoginManager defaultManager] currentUser] loadIntoMOC:moc];
        decision = [Decision createDecisionInContext:moc];
        [decision setUser:user];
        [vc setEditMode:YES];
    }
    else if ([sender isKindOfClass:[IDDecisionCell class]]) {
        vc = [segue destinationViewController];
        decision = [sender decision];
    }
    else
        NSAssert(NO, @"Unknown sender!");
    
    [vc setDecision:decision];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self decisions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Decision * decision = [[self decisions] objectAtIndex:indexPath.row];
    
    IDDecisionCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IDDecisionCell class])];
    [cell setupWithDecision:decision];
    
    return cell;
}

@end
