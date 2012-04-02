//
//  Message+Extras.m
//  Decide
//
//  Created by Robert Brown on 3/30/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Message+Extras.h"

@implementation Message (Extras)

+ (Message *)createMessageInContext:(NSManagedObjectContext *)context {
    
    Message * message = (Message *)[self createManagedObjectInContext:context];
    
    return message;
}

@end
