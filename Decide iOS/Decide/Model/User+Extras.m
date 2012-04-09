//
//  User+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "User+Extras.h"
#import "RBReporter.h"

@implementation User (Extras)

+ (User *)createUserWithUsername:(NSString *)username inContext:(NSManagedObjectContext *)context {
    
    NSParameterAssert(username && context);
    
    User * user = (User *)[self createManagedObjectInContext:context];
    [user setUsername:username];
    
    return user;
}

@end
