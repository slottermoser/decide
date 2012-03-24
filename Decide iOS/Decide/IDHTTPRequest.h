//
//  IDHTTPRequest.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IDHTTPRequestBlock)(NSString * errMsg, NSError * error);

@interface IDHTTPRequest : NSObject

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDHTTPRequestBlock)block;

- (void)logoutBlock:(IDHTTPRequestBlock)block;

@end
