//
//  Decision.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IDObject.h"

@class Discussion, Option, User;

@interface Decision : IDObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) Discussion *discussion;
@property (nonatomic, retain) Option *options;
@property (nonatomic, retain) NSSet *user;
@end

@interface Decision (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
