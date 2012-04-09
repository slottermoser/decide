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
#import "Option+Extras.h"
#import "IDHTTPRequest.h"
#import "RBReporter.h"
#import "UITableView+RBExtras.h"

@interface IDDecisionDetailVC ()

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * discussionButton;

- (IBAction)cancel:(id)sender;

- (IBAction)save:(id)sender;

- (void)reportServerError:(NSError *)error;

- (void)uploadAndSaveOptionsForDecision:(Decision *)decision;

- (void)uploadAndSaveDecision:(Decision *)decision;

@end


@implementation IDDecisionDetailVC

@synthesize tableView        = _tableView;
@synthesize decision         = _decision;
@synthesize editMode         = _editMode;
@synthesize discussionButton = _discussionButton;

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)reportServerError:(NSError *)error {
    [RBReporter logError:error];
    [RBReporter presentAlertWithTitle:@"Error"
                              message:@"Couldn't save to the server."];
}

- (void)uploadAndSaveOptionsForDecision:(Decision *)decision {
    
    // Creates all the Options on the server too.
    [[decision options] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        Option * option = obj;
        [[IDHTTPRequest new] createOption:option block:
         ^(id response, NSError * error) {
             
             if (error) {
                 *stop = YES;
                 [self reportServerError:error];
                 return;
             }
             else {
                 // Grabs the ID from the server.
                 [option setObjID:[response valueForKey:@"id"]];
                 
                 if (idx == [[decision options] count] - 1)
                     if (![[self moc] save:&error]) {
                         [RBReporter logError:error];
                         [RBReporter presentAlertWithTitle:@"Error"
                                                   message:@"Couldn't save the Decision."];
                     }
                     else
                         [self dismissModalViewControllerAnimated:YES];
             }
         }];
    }];
}

- (void)uploadAndSaveDecision:(Decision *)decision {
    
    // Creates a Decision object on the server first.
    [[IDHTTPRequest new] createDecision:decision block:
     ^(id response, NSError * error) {
         
         if (error) {
             [self reportServerError:error];
             return;
         }
         else {
             // Grabs the ID from the server.
             [decision setObjID:[response valueForKey:@"id"]];
             
             [self uploadAndSaveOptionsForDecision:decision];
         }
     }];
}

- (IBAction)save:(id)sender {
    [self uploadAndSaveDecision:[self decision]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert([self decision], @"No decision.");
    
    if ([self isInEditMode]) {
        UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                       target:self
                                                                                       action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        
        UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                     target:self
                                                                                     action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:saveButton];
    }
}

- (void)viewDidUnload {
    [self setDiscussionButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self isInEditMode])
        return [[[self decision] options] count] + 2;
    else
        return [[[self decision] options] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IDDecisionDetailCell * cell = nil;
    BOOL inEditMode = [self isInEditMode];
    Decision * decision = [self decision];
    
    // Creates the cell.
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
    
    // Sets up the cell.
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
    
    [cell setTextFieldDelegate:self];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IDDecisionDetailCell * cell = (IDDecisionDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    Option * option = [cell option];
    
    if (option) {
        
        if ([[option voted] boolValue]) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [option downvote];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [option upvote];
        }
        
        NSError * error = nil;
        if ([[option managedObjectContext] save:&error])
            [RBReporter logError:error];
        
        [cell update];
    }
    
    [[self tableView] deselectSelectedRowAnimated:YES];
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // !!!: This logic is commented out because the move to next field doesn't work right now.
    
//    IDDecisionDetailCell * cell = (IDDecisionDetailCell *)[[textField superview] superview];
//    NSIndexPath * indexPath = [[self tableView] indexPathForCell:cell];
//    NSInteger rowCount = [[[self tableView] dataSource] tableView:[self tableView]
//                                            numberOfRowsInSection:0];
    
//    // The last text field has the "Done" button.
//    if (indexPath.row == rowCount - 1)
        [textField setReturnKeyType:UIReturnKeyDone];
//    // All other fields have the "Next" button.
//    else
//        [textField setReturnKeyType:UIReturnKeyNext];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    IDDecisionDetailCell * cell = (IDDecisionDetailCell *)[[textField superview] superview];
    NSIndexPath * indexPath = [[self tableView] indexPathForCell:cell];
    NSInteger rowCount = [[[self tableView] dataSource] tableView:[self tableView]
                                             numberOfRowsInSection:0];
    NSString * text = [textField text];
    
    if ([cell decision]) {
        [[self decision] setText:[textField text]];
    }
    else {
        // If this is the new option row.
        if (indexPath.row - 1 == [[[self decision] options] count]) {
            
            if (text && [text length] > 0) {
                Option * option = [Option createManagedObjectInContext:[self moc]];
                [option setDecision:[self decision]];
                [option setText:text];
                [[self tableView] reloadData];
            }
        }
        // Otherwise, this is editing an existing option row. 
        else {
            [[cell option] setText:text];
        }
    }
    
    [textField resignFirstResponder];
    
    // Makes the next text field the first responder. 
    if (indexPath.row < rowCount) {
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                         inSection:indexPath.section];
        IDDecisionDetailCell * nextCell = nil;
        nextCell = (IDDecisionDetailCell *)[[[self tableView] dataSource] tableView:[self tableView]
                                                              cellForRowAtIndexPath:nextIndexPath];
        [[nextCell textField] becomeFirstResponder];  // ???: Why doesn't this work?
    }
    
    return YES;
}

@end
