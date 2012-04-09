//
//  IDHTTPRequest.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDHTTPRequest.h"
#import "AFJSONRequestOperation.h"
#import "Decision+Extras.h"
#import "Option+Extras.h"
#import "Message+Extras.h"
#import "Discussion+Extras.h"
#import "RBCoreDataManager.h"

NSString * const kBaseURL = @"http://decide.dshumes.com";

NSString * const IDHTTPRequestErrorKey = @"error";

NSString * const IDHTTPRequestErrorDomain = @"IDHTTPRequestErrorDomain";
const NSInteger IDHTTPRequestLoginErrorCode = 123; 
const NSInteger IDHTTPRequestLogoutErrorCode = 124; 
const NSInteger IDHTTPRequestUnknownErrorCode = 999;

//static 

@implementation IDHTTPRequest


#pragma mark - Helper methods

+ (NSURL *)baseURL {
    
    static NSURL * _baseURL = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _baseURL = [NSURL URLWithString:kBaseURL];
    });
    
    return _baseURL;
}

- (NSMutableURLRequest *)mutableURLRequestWithPath:(NSString *)path method:(NSString *)method jsonBody:(NSString *)json {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path
                                                                               relativeToURL:[[self class] baseURL]]];
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:method];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    return request;
}

- (void)performRequest:(NSURLRequest *)request block:(IDHTTPRequestBlock)block {
    
    AFJSONRequestOperation * op = nil;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                         success:
          ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
              
              NSString * errStr = 
              ([JSON isKindOfClass:[NSDictionary class]]) ? 
              [JSON valueForKey:IDHTTPRequestErrorKey] : 
              nil;
              
              if (errStr) {
                  NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                             errStr, NSLocalizedDescriptionKey,
                                             nil];
                  NSError * error = [NSError errorWithDomain:IDHTTPRequestErrorDomain
                                                        code:IDHTTPRequestUnknownErrorCode
                                                    userInfo:userInfo];
                  block(errStr, error);
              }
              else
                  block(JSON, nil);
              
          } failure:
          ^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error, id JSON) {
              block(nil, error);
          }];
    [op start];
}


#pragma mark - Authorization

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(username && password && block);
    
    NSString * json = [NSString stringWithFormat:
                       @"{\"user\":{\"email\":\"%@\",\"password\":\"%@\",\"remember_me\":\"0\"}}", 
                       username, 
                       password];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/users/sign_in.json" 
                                                             method:@"POST" 
                                                           jsonBody:json];
    [self performRequest:request block:block];
}

- (void)logoutBlock:(IDHTTPRequestBlock)block {
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/users/sign_out.json" 
                                                             method:@"DELETE" 
                                                           jsonBody:@"{}"];
    [self performRequest:request block:block];
}


#pragma mark - Decisions

- (void)createDecision:(Decision *)decision block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(decision);
    
    NSString * json = [NSString stringWithFormat:
                       @"{\"title\":\"%@\"}", 
                       [decision text]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/decisions.json" 
                                                             method:@"POST" 
                                                           jsonBody:json];
    [self performRequest:request block:block];
}

- (void)decisionWithID:(NSUInteger)objID block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%u.json", 
                       objID];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

- (void)decisionsWithBlock:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/decisions.json"
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:^(id response, NSError * error) {
        
        if (error) {
            block(nil, error);
        }
        else {
            NSMutableArray * decisions = [NSMutableArray arrayWithCapacity:[response count]];
            NSManagedObjectContext * moc = [[RBCoreDataManager defaultManager] createMOC];
            
            for (NSDictionary * decision in response)
                [decisions addObject:[Decision createDecisionFromDictionary:decision
                                                                  inContext:moc]];
            block(decisions, nil);
        }
    }];
}


#pragma mark - Options

- (void)createOption:(Option *)option block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(option);
    
    NSString * json = [NSString stringWithFormat:
                       @"{\"title\":\"%@\"}", 
                       [option text]];
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%@/choices/new.json",
                       [[option decision] objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"POST" 
                                                           jsonBody:json];
    [self performRequest:request block:block];
}

- (void)optionWithID:(NSUInteger)objID inDecision:(Decision *)decision block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    // ???: How do I get an Option? There is not method for it. Do I get it with a Decision?
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%@/options/create.json",
                       [decision objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}


#pragma mark - Discussions

- (void)discussionWithDecisionID:(NSUInteger)objID block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%u/discussion.json",
                       objID];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

- (void)createMessage:(Message *)message block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(message);
    
    NSString * json = [NSString stringWithFormat:
                       @"{\"entry\":\"%@\"}", 
                       [message text]];
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%@/discussion_entries/create.json",
                       [[[message discussion] decision] objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"POST" 
                                                           jsonBody:json];
    [self performRequest:request block:block];
}

- (void)messageWithID:(NSUInteger)objID inDecision:(Decision *)decision block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    NSString * path = [NSString stringWithFormat:
                       @"/decisions/%@/discussion_entries/%u.json",
                       [decision objID],
                       objID];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}


#pragma mark - Votes

- (void)upvoteOption:(Option *)option block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(option);
    
    NSString * path = [NSString stringWithFormat:
                       @"/choices/%@/vote.json",
                       [option objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"POST" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

- (void)upvoteOptionWithID:(NSUInteger)optionID block:(IDHTTPRequestBlock)block {
    
    NSString * path = [NSString stringWithFormat:
                       @"/choices/%u/vote.json",
                       optionID];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

- (void)downvoteOption:(Option *)option block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(option);
    
    NSString * path = [NSString stringWithFormat:
                       @"/choices/%@/delete_vote.json",
                       [option objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

@end
