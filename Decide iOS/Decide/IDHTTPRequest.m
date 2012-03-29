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

NSString * const kBaseURL = @"http://decide.dshumes.com";

NSString * const IDHTTPRequestErrorKey = @"error";

NSString * const IDHTTPRequestErrorDomain = @"IDHTTPRequestErrorDomain";
const NSInteger IDHTTPRequestLoginErrorCode = 123; 
const NSInteger IDHTTPRequestLogoutErrorCode = 124; 

@implementation IDHTTPRequest

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
              
              NSString * errStr = [JSON valueForKey:IDHTTPRequestErrorKey];
              
              if (errStr) {
                  NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                             errStr, NSLocalizedDescriptionKey,
                                             nil];
                  NSError * error = [NSError errorWithDomain:IDHTTPRequestErrorDomain
                                                        code:IDHTTPRequestLogoutErrorCode
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
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/decisions/create.json" 
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


#pragma mark - Options

- (void)createOption:(Option *)option block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(option);
    
    NSString * json = [NSString stringWithFormat:
                       @"{\"title\":\"%@\", \"decision_id\":%@}", 
                       [option text],
                       [[option decision] objID]];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:@"/options/create.json" 
                                                             method:@"POST" 
                                                           jsonBody:json];
    [self performRequest:request block:block];
}

- (void)optionWithID:(NSUInteger)objID block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(block);
    
    NSString * path = [NSString stringWithFormat:
                       @"/options/%u.json", 
                       objID];
    
    NSMutableURLRequest * request = [self mutableURLRequestWithPath:path
                                                             method:@"GET" 
                                                           jsonBody:@""];
    [self performRequest:request block:block];
}

@end
