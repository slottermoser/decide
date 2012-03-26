//
//  IDBaseVC.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDBaseVC.h"

@interface IDBaseVC () {
    @private
    NSManagedObjectContext * _moc;
}

@property (nonatomic, strong, readwrite) NSManagedObjectContext * moc;

@end


@implementation IDBaseVC

@synthesize moc = _moc;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSManagedObjectContext *)moc {
    
    if (!_moc) {
        @synchronized(self) {
            if (!_moc) _moc = [[RBCoreDataManager sharedManager] createMOC];
        }
    }
    
    return _moc;
}

@end
