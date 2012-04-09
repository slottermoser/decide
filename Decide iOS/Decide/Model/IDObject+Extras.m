//
//  IDObject+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDObject+Extras.h"
#import "RBReporter.h"

@implementation IDObject (Extras)

- (BOOL)validateCreationDate:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError {
    
    // If there isn't a date, then it is set to now.
    if (!*ioValue)
        *ioValue = [NSDate date];
    
    return YES;
}

+ (id)objectWithID:(NSUInteger)objID inContext:(NSManagedObjectContext *)context {
    
    NSParameterAssert(context);
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"objID = %u", objID]];
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
    
    [RBReporter logError:error];
    
    return [results lastObject];
}

@end
