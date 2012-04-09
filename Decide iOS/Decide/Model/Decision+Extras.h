//
//  Decision+Extras.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Decision.h"
#import "IDObject+Extras.h"

@interface Decision (Extras)

+ (Decision *)createDecisionInContext:(NSManagedObjectContext *)context;

+ (Decision *)createDecisionFromDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end
