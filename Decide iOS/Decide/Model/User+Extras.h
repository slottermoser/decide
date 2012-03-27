//
//  User+Extras.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "User.h"
#import "IDObject+Extras.h"

@interface User (Extras)

+ (User *)createUserWithUsername:(NSString *)username inContext:(NSManagedObjectContext *)context;

@end
