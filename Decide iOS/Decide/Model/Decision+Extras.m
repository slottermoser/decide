//
//  Decision+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Decision+Extras.h"

@implementation Decision (Extras)

+ (Decision *)createDecisionInContext:(NSManagedObjectContext *)context {
    
    Decision * decision = [self createManagedObjectInContext:context];
    
    return decision;
}

@end
