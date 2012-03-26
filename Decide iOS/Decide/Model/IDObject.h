//
//  IDObject.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IDObject : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;

@end
