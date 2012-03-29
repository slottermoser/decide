//
//  IDDecisionDetailVC.h
//  Decide
//
//  Created by Robert Brown on 3/23/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDBaseVC.h"

@class Decision;

@interface IDDecisionDetailVC : IDBaseVC <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) Decision * decision;
@property (nonatomic, assign, getter=isInEditMode) BOOL editMode;

@end
