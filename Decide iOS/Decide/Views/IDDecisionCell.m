//
//  IDDecisionCell.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDDecisionCell.h"
#import "Decision+Extras.h"


@interface IDDecisionCell ()

@property (nonatomic, strong, readwrite) Decision * decision;
@property (nonatomic, strong) IBOutlet UILabel * decisionNameLabel;
@property (nonatomic, strong) IBOutlet UILabel * dateLabel;

@end


@implementation IDDecisionCell

@synthesize decision          = _decision;
@synthesize decisionNameLabel = _decisionNameLabel;
@synthesize dateLabel         = _dateLabel;

+ (NSDateFormatter *)dateFormatter {
    
    static NSDateFormatter * _dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    });
    
    return _dateFormatter;
}

- (void)setupWithDecision:(Decision *)decision {
    [self setDecision:decision];
    [[self decisionNameLabel] setText:[decision text]];
    [[self dateLabel] setText:[[[self class] dateFormatter] stringFromDate:[decision deadline]]];
}

@end
