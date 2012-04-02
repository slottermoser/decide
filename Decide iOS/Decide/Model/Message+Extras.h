//
//  Message+Extras.h
//  Decide
//
//  Created by Robert Brown on 3/30/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "Message.h"
#import "IDObject+Extras.h"

@interface Message (Extras)

+ (Message *)createMessageInContext:(NSManagedObjectContext *)context;

@end
