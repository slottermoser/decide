//
//  Option+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Option+Extras.h"
#import "RBReporter.h"
#import "Decision+Extras.h"
#import "IDHTTPRequest.h"

@implementation Option (Extras)

+ (Option *)createOptionInContext:(NSManagedObjectContext *)context {
    
    Option * option = (Option *)[self createManagedObjectInContext:context];
    
    return option;
}

+ (Option *)createOptionFromDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context {
    
    Option * opt = (Option *)([self objectWithID:[[dict valueForKey:@"id"] unsignedIntegerValue]
                                       inContext:context] ?:
                              [self createOptionInContext:context]);
    
    [opt setText:[dict valueForKey:@"title"]];
    [opt setObjID:[dict valueForKey:@"id"]];
    [opt setVoteCount:[dict valueForKey:@"vote_count"]];
    [opt setDecision:(Decision *)[Decision objectWithID:[[dict valueForKey:@"decision_id"] unsignedIntegerValue]
                                              inContext:context]];
    
    return opt;
}

- (void)upvote {
    if ([[self voted] boolValue])
        return;
    
    [self setVoted:[NSNumber numberWithBool:YES]];
    NSInteger newVoteCount = [[self voteCount] integerValue] + 1;
    [self setVoteCount:[NSNumber numberWithInteger:newVoteCount]];
    
    [[IDHTTPRequest new] upvoteOptionWithID:[[self objID] unsignedIntegerValue]
                                block:
     ^(id response, NSError * error) {
         [RBReporter logError:error];
     }];
}

- (void)downvote {
    if (![[self voted] boolValue])
        return;
    
    [self setVoted:[NSNumber numberWithBool:NO]];
    NSInteger newVoteCount = [[self voteCount] integerValue] - 1;
    [self setVoteCount:[NSNumber numberWithInteger:newVoteCount]];
    
    [[IDHTTPRequest new] downvoteOption:self
                                  block:
     ^(id response, NSError * error) {
         [RBReporter logError:error];
     }];
}

@end
