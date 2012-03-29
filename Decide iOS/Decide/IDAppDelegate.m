//
//  IDAppDelegate.m
//  Decide
//
//  Created by Robert Brown on 3/21/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import "IDAppDelegate.h"
#import "UAirship.h"

@implementation IDAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"Application launched with options: %@", launchOptions);
    
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
    NSLog(@"Application resigning active.");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Application entered background.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"Application entering foreground.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"Application activating.");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application terminating.");
    [UAirship land];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"Successfully registered and received device token: %@", deviceToken);
    
    // Updates the device token and registers the token with UA
    [[UAirship shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote registration failed with error: %@", [error localizedDescription]);
}

@end
