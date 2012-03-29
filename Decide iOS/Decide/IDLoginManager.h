//
//  IDLoginManager.h
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IDLoginBlock)(id response, NSError * error);

@class User;


@interface IDLoginManager : NSObject

@property (nonatomic, copy, readonly) NSString * currentUsername;

+ (IDLoginManager *)defaultManager;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDLoginBlock)block;

- (User *)currentUser;

@end
