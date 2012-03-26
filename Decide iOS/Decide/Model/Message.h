//
//  Message.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IDObject.h"

@class Discussion;

@interface Message : IDObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Discussion *discussion;

@end
