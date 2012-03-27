//
//  IDDecisionDetailCell.m
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionDetailCell.h"
#import "Decision+Extras.h"
#import "Option+Extras.h"


@interface IDDecisionDetailCell ()

@property (nonatomic, strong, readwrite) Decision * decision;
@property (nonatomic, strong, readwrite) Option * option;
@property (nonatomic, assign, getter=isInEditMode) BOOL editMode;
@property (nonatomic, strong) IBOutlet UILabel * mainLabel;
@property (nonatomic, strong) IBOutlet UILabel * detailLabel;
@property (nonatomic, strong) IBOutlet UILabel * rightLabel;
@property (nonatomic, strong) IBOutlet UITextField * textField;

@end


@implementation IDDecisionDetailCell

@synthesize decision    = _decision;
@synthesize option      = _option;
@synthesize editMode    = _editMode;
@synthesize mainLabel   = _mainLabel;
@synthesize detailLabel = _detailLabel;
@synthesize rightLabel  = _rightLabel;
@synthesize textField   = _textField;

- (void)setupWithDecision:(Decision *)decision editMode:(BOOL)editMode {
    [self setDecision:decision];
    [self setOption:nil];
    [self setupWithMainText:@"Decision"
                 detailText:[decision text]
                  rightText:nil 
                   editMode:editMode];
}

- (void)setupWithOption:(Option *)option editMode:(BOOL)editMode {
    [self setOption:option];
    [self setDecision:nil];
    [self setupWithMainText:@"Option"
                 detailText:[option text] 
                  rightText:[NSString stringWithFormat:@"%d", [[option voteCount] integerValue]]
                   editMode:editMode];
}

- (void)setupWithMainText:(NSString *)mainText detailText:(NSString *)detailText rightText:(NSString *)rightText editMode:(BOOL)editMode {
    
    [self setEditMode:editMode];
    [[self detailLabel] setHidden:(editMode)];
    [[self textField] setHidden:(!editMode)];
    
    if (editMode)
        [[self textField] setText:detailText];
    else {
        [[self detailLabel] setText:detailText];
        [[self rightLabel] setText:rightText];
    }
}

@end
