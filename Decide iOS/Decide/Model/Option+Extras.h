//
//  Option+Extras.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Option.h"
#import "IDObject+Extras.h"

@interface Option (Extras)

+ (Option *)createOptionInContext:(NSManagedObjectContext *)context;

@end
