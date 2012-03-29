//
//  Option+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Option+Extras.h"

@implementation Option (Extras)

+ (Option *)createOptionInContext:(NSManagedObjectContext *)context {
    
    Option * option = (Option *)[self createManagedObjectInContext:context];
    
    return option;
}

@end
