//
//  IDAppDelegate.m
//  Decide
//
//  Created by Robert Brown on 3/21/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDAppDelegate.h"
#import "UAirship.h"
#import "RBReporter.h"


@implementation IDAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [RBReporter logDebugMessage:[NSString stringWithFormat:
                                 @"Application launched with options: %@", 
                                 launchOptions]];
    
    // TODO: Check the launch options for notification payload. 
    
    //Init Airship launch options
    NSMutableDictionary * takeOffOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            launchOptions, UAirshipTakeOffOptionsAnalyticsKey, 
                                            nil];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    [UAirship takeOff:takeOffOptions];
    
    // Register for notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    [RBReporter logDebugMessage:@"Application resigning active."];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [RBReporter logDebugMessage:@"Application entered background."];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [RBReporter logDebugMessage:@"Application entering foreground."];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [RBReporter logDebugMessage:@"Application activating."];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [RBReporter logDebugMessage:@"Application terminating."];
    [UAirship land];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [RBReporter logDebugMessage:[NSString stringWithFormat:
                                 @"Successfully registered and received device token: %@", 
                                 deviceToken]];
    
    // Updates the device token and registers the token with UA
    [[UAirship shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [RBReporter logDebugMessage:[NSString stringWithFormat:
                                 @"Remote registration failed with error: %@", 
                                 [error localizedDescription]]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [RBReporter logDebugMessage:[NSString stringWithFormat:
                                 @"Application received remote notification: %@", 
                                 userInfo]];
    
    // TODO: Handle the received notifications.
}

@end
