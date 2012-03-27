//
//  IDDecisionCell.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Decision;

@interface IDDecisionCell : UITableViewCell

@property (nonatomic, strong, readonly) Decision * decision;

- (void)setupWithDecision:(Decision *)decision;

@end
