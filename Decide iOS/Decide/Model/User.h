//
//  User.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IDObject.h"

@class Decision, Group, Preferences;

@interface User : IDObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *decisions;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) Preferences *preferences;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDecisionsObject:(Decision *)value;
- (void)removeDecisionsObject:(Decision *)value;
- (void)addDecisions:(NSSet *)values;
- (void)removeDecisions:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
