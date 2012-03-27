//
//  IDDecisionDetailCell.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Decision;
@class Option;

@interface IDDecisionDetailCell : UITableViewCell

@property (nonatomic, strong, readonly) Decision * decision;
@property (nonatomic, strong, readonly) Option * option;

- (void)setupWithDecision:(Decision *)decision editMode:(BOOL)editMode;

- (void)setupWithOption:(Option *)option editMode:(BOOL)editMode;

@end
