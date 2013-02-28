//
//  SIKAppDelegate.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/24/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKAppDelegate.h"
#import "SIKViewController.h"
#import "HSLUpdateChecker.h"
#import "Helpshift.h"
#import "TestFlight.h"

#import <Crashlytics/Crashlytics.h>

@implementation SIKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Helpshift installForAppID:@"simpleink_platform_20130201172045673-b81832eca26a1dc" domainName:@"simpleink.helpshift.com" apiKey:@"385f52c29a35224e2dc1e57c0d8c621a"];
    [TestFlight takeOff:@"10a4758878361bac65baba13f2424c3d_NzM3OTAyMDEyLTA1LTIzIDA4OjQxOjQ3LjEwMzAzOA"];
    [Crashlytics startWithAPIKey:@"28c8692e863cd8d9f1f9575ab4245e49da550d33"];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [((SIKViewController *)self.window.rootViewController) hideBannerAd];
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
    [((SIKViewController *)self.window.rootViewController) startBannerAd];
    
    [MKStoreManager sharedManager];
    
    [HSLUpdateChecker checkForUpdate];
    
    [USER_DEFAULTS setBool:NO forKey:@"isMakingPurchase"];
    [USER_DEFAULTS setBool:NO forKey:@"isRestoringPurchase"];
    [USER_DEFAULTS synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
