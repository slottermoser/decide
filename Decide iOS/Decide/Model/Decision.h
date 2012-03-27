//
//  Decision.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IDObject.h"

@class Discussion, Option, User;

@interface Decision : IDObject

@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Discussion *discussion;
@property (nonatomic, retain) NSOrderedSet *options;
@property (nonatomic, retain) User *user;
@end

@interface Decision (CoreDataGeneratedAccessors)

- (void)insertObject:(Option *)value inOptionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOptionsAtIndex:(NSUInteger)idx;
- (void)insertOptions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOptionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOptionsAtIndex:(NSUInteger)idx withObject:(Option *)value;
- (void)replaceOptionsAtIndexes:(NSIndexSet *)indexes withOptions:(NSArray *)values;
- (void)addOptionsObject:(Option *)value;
- (void)removeOptionsObject:(Option *)value;
- (void)addOptions:(NSOrderedSet *)values;
- (void)removeOptions:(NSOrderedSet *)values;
@end
