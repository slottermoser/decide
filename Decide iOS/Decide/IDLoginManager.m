//
//  IDLoginManager.m
//  Decide
//
//  Created by Robert Brown on 3/26/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDLoginManager.h"
#import "IDHTTPRequest.h"
#import "User+Extras.h"
#import "RBCoreDataManager.h"
#import "RBReporter.h"


@interface IDLoginManager ()

@property (nonatomic, copy, readwrite) NSString * currentUsername;
@property (nonatomic, strong) NSManagedObjectContext * moc;

@end


@implementation IDLoginManager

@synthesize currentUsername = _currentUsername;
@synthesize moc             = _moc;

+ (IDLoginManager *)defaultManager {
    
    static IDLoginManager * _defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [IDLoginManager new];
    });
    
    return  _defaultManager;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(IDLoginBlock)block {
    IDHTTPRequest * request = [IDHTTPRequest new];
    [request loginWithUsername:username
                      password:password
                         block:
     ^(id response, NSError * error){
         
         if (response && !error) {
             [self setCurrentUsername:username];
             
             User * user = [self currentUser];
             
             if (!user) {
                 NSManagedObjectContext * moc = [self moc];
                 user = [User createUserWithUsername:[self currentUsername]
                                           inContext:moc];
                 
                 [user setObjID:[response valueForKey:@"id"]];
                 error = nil;
                 
                 [moc save:&error];
                 
                 [RBReporter logError:error];
             }
             
         }
         
         if (block)
             block(response, error);
     }];
}

- (NSManagedObjectContext *)moc {
    
    if (!_moc) {
        @synchronized(self) {
            if (!_moc) _moc = [[RBCoreDataManager defaultManager] createMOC];
        }
    }
    
    return _moc;
}

- (User *)currentUser {
    
    if (![self currentUsername])
        return nil;
    
    NSManagedObjectContext * moc = [self moc];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    [request setPredicate:[NSPredicate predicateWithFormat:@"username = %@", [self currentUsername]]];
    
    NSError * error = nil;
    NSArray * results = [moc executeFetchRequest:request
                                           error:&error];
    [RBReporter logError:error];
    
    return [results lastObject];
}

@end
