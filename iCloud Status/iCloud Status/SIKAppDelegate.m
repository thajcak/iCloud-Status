//
//  SIKAppDelegate.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/24/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKAppDelegate.h"
#import "SIKViewController.h"

//#import <Crashlytics/Crashlytics.h>

@implementation SIKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([USER_DEFAULTS valueForKey:@"PUSH OPTION SET"]) {
//        if ([[UAPush shared] pushEnabled]) {
//            [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//        }
    }
    
    if (![USER_DEFAULTS valueForKey:@"HAS SUPPORT PUSH"]) {
        [USER_DEFAULTS setBool:NO forKey:@"HAS SUPPORT PUSH"];
        [USER_DEFAULTS synchronize];
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [((SIKViewController *)self.window.rootViewController) updateStatus];
    
//    [[UAPush shared] resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[Helpshift sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [[Helpshift sharedInstance] handleNotification:userInfo withController:self.window.rootViewController];
    [USER_DEFAULTS setBool:YES forKey:@"HAS SUPPORT PUSH"];
    [USER_DEFAULTS synchronize];
    
    [((SIKViewController *)self.window.rootViewController) updateSupportFeedbackBadgeAnimated:YES];
}

@end
