//
//  IDHTTPRequest.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IDHTTPRequestBlock)(id response, NSError * error);

@class Decision;
@class Option;

@interface IDHTTPRequest : NSObject

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDHTTPRequestBlock)block;

- (void)logoutBlock:(IDHTTPRequestBlock)block;

- (void)decisionWithID:(NSUInteger)objID block:(IDHTTPRequestBlock)block;

- (void)createDecision:(Decision *)decision block:(IDHTTPRequestBlock)block;

- (void)decisionsWithBlock:(IDHTTPRequestBlock)block;

- (void)participatingDecisionsWithBlock:(IDHTTPRequestBlock)block;

- (void)createOption:(Option *)option block:(IDHTTPRequestBlock)block;

- (void)optionWithID:(NSUInteger)objID inDecision:(Decision *)decision block:(IDHTTPRequestBlock)block;

- (void)upvoteOption:(Option *)option block:(IDHTTPRequestBlock)block;

- (void)upvoteOptionWithID:(NSUInteger)optionID block:(IDHTTPRequestBlock)block;

- (void)downvoteOption:(Option *)option block:(IDHTTPRequestBlock)block;

- (void)discussionWithDecisionID:(NSUInteger)objID block:(IDHTTPRequestBlock)block;

@end
