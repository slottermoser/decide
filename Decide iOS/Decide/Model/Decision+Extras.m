//
//  Decision+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Decision+Extras.h"
#import "User+Extras.h"
#import "Option+Extras.h"

@implementation Decision (Extras)

+ (Decision *)createDecisionInContext:(NSManagedObjectContext *)context {
    
    Decision * decision = [self createManagedObjectInContext:context];
    
    return decision;
}

+ (Decision *)createDecisionFromDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context {
    
    NSParameterAssert(dict && context);
    
    Decision * decision = (Decision *)([self objectWithID:[[dict valueForKey:@"id"] unsignedIntegerValue]
                                                inContext:context] ?:
                                       [self createDecisionInContext:context]);
    
    [decision setText:[dict valueForKey:@"title"]];
    [decision setObjID:[dict valueForKey:@"id"]];
    [decision setUser:(User *)[User objectWithID:[[dict valueForKey:@"user_id"] unsignedIntegerValue]
                                       inContext:context]];
    
    for (NSDictionary * optDict in [dict valueForKey:@"choices"]) {
        Option * opt = [Option createOptionFromDictionary:optDict
                                                inContext:context];
        [opt setDecision:decision];

        // Handles the case when I have voted for something. 
//        NSString * keypath = [NSString stringWithFormat:@"my_votes.%@", [opt objID]];
//        [opt setVoted:[dict valueForKeyPath:keypath]];
    }
    
    return decision;
}

@end
