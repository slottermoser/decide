//
//  IDHTTPRequest.m
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDHTTPRequest.h"
#import "AFJSONRequestOperation.h"

NSString * const kBaseURL = @"http://decide.dshumes.com";

NSString * const IDHTTPRequestErrorKey = @"error";

NSString * const IDHTTPRequestErrorDomain = @"IDHTTPRequestErrorDomain";
const NSInteger IDHTTPRequestLoginErrorCode = 123; 
const NSInteger IDHTTPRequestLogoutErrorCode = 123; 

@implementation IDHTTPRequest

+ (NSURL *)baseURL {
    
    static NSURL * _baseURL = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _baseURL = [NSURL URLWithString:kBaseURL];
    });
    
    return _baseURL;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDHTTPRequestBlock)block {
    
    NSParameterAssert(username && password && block);
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/users/sign_in.json"
                                                                               relativeToURL:[[self class] baseURL]]];
    [request setHTTPMethod:@"POST"];
    NSString * bodyStr = [NSString stringWithFormat:
                          @"{\"user\":{\"email\":\"%@\",\"password\":\"%@\",\"remember_me\":\"0\"}}", 
                          username, 
                          password];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
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
                                                        code:IDHTTPRequestLoginErrorCode
                                                    userInfo:userInfo];
                  block(errStr, error);
              }
              else
                  block(nil, nil);
              
          } failure:
          ^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error, id JSON) {
              block([JSON valueForKey:IDHTTPRequestErrorKey], error);
          }];
    [op start];
}

- (void)logoutBlock:(IDHTTPRequestBlock)block {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/users/sign_out.json"
                                                                               relativeToURL:[[self class] baseURL]]];
    [request setHTTPMethod:@"DELETE"];
    NSString * bodyStr = [NSString stringWithFormat:@"{}"];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    AFJSONRequestOperation * op = nil;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                         success:
          ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
              
              NSString * errStr = [JSON valueForKey:@"error"];
              
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
                  block(nil, nil);
              
          } failure:
          ^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error, id JSON) {
              block([JSON valueForKey:IDHTTPRequestErrorKey], error);
          }];
    [op start];
}

@end
