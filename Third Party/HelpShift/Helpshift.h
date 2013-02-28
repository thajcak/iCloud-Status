/*
 *    Helpshift.h
 *    SDK version 1.4.5
 *
 *    Get the documentation at http://www.helpshift.com/docs
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**

Installing helpshift support to your app
 
To download the SDK you must be logged in to your Helpshift admin dashboard. Go to the home page (_yourcompany_.helpshift.com/admin/) and click the *download* button in the sidebar on right of the page to get the zip file.
The zip file contains

- Helpshift.h : header file
- libHelpshift.a : static library
- A resources folder containing the images required by the library
 
Adding the Helpshift SDK to your application
 
- Just unzip the zip file you have downloaded, and drag and drop its contents to your XCode project.
- Make sure that in the **Build Phases** of your target application Helpshift.h is in **Copy Headers**, also libHelpshift.a is in the **Link Binary with Libraries** and the PNGs are in **Copy Bundle Resources**.
- Add the following dependencies to your project
    - CoreGraphics
    - QuartzCore
    - SystemConfiguration
    - MobileCoreServices
    - OpenGLES
    - CoreTelephony
    - Security
    - Foundation Frameworks
    - libz.dylib
        
Helpshift is now integrated into your application !

Next steps

- Authentication tokens
    - To get the API key, Domain Name, App ID you must be logged into your Helpshift admin dashboard. Go to the home page (_yourcompany_.helpshift.com/admin/) and click **Download** button in the sidebar on right of the page. Here you will find the _API Key_, _Domain Name_ and _App ID_.
    - When initializing Helpshift you must pass these three tokens. You initialize Helpshift by calling the installForAppID:domainName:apiKey: , ideally at the top of application:didFinishLaunchingWithOptions:
- Show the support screen by using the showSupport: api


**Integrating Urban Airship into your App**
 
 - Get a valid Urban Airship account. Get yours [here](https://go.urbanairship.com/accounts/register/).
 - Follow the steps described [here](https://docs.urbanairship.com/display/DOCS/Getting+Started%3A+iOS%3A+Push) to setup your application with Apple and enable push notifications.
 - Implement the Urban Airship calls in your app with the following [steps](https://docs.urbanairship.com/display/DOCS/Client%3A+iOS%3A+Push).
 - It is recommended that you enable the auto badge feature described [here](https://docs.urbanairship.com/display/DOCS/Client%3A+iOS%3A+Push#ClientiOSPush-Badges).
 
 For Helpshift Admin interface
 
 - To enable the helpshift system to send push notifications to your users you will have to add your ‘Application Key’ and ‘Application Master Secret’ keys via the helpshift admin interface.
 - If you have multiple apps within a single helpshift instance, you will have to create the same number of apps in Urban Airship.
 - Enter your Urban Airship credentials per app, via the Settings > Apps page in your Helpshift Admin instance.

![Image](https://d3e51fp79zp4el.cloudfront.net/docs/ua_keys.gif)
 
 - You can check if your test device is registered via the admin panel on Urban Airship

![Image](https://d3e51fp79zp4el.cloudfront.net/docs/ua_device_token.gif)
 
 For Helpshift iOS SDK
 
 - Once you have integrated Urban Airship with your application, you can use the registerDeviceToken: and handleNotification:withController: api calls to use helpshift push notifications in your application. 

 @warning **Important: Orientation issues with iOS 6**
 
 To account for the changes in iOS 6 with autorotation and interface orientations, we suggest a few precautionary measures to avoid issues with the Helpshift SDK.
 
 - The Helpshift SDK uses UIImagePickerController, which according to Apple docs supports portrait mode only (and not portrait upside down).
 
 - This means if your application's supported interface orientations does not include portrait mask, then when choosing a screenshot the application will crash. So please make sure that your application's list of supported interface orientations does not exclude portrait out.
 
 To give you an idea, if you add something like this to your application delegate, it will avoid the crash.
 
    -(NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
    {
        return UIInterfaceOrientationMaskAll;
    }
 
 
 _Finally, it depends upon your application how you implement these requirements._
 
*/

@protocol HelpshiftDelegate;
@interface Helpshift : NSObject <UIAlertViewDelegate>
{
    id <HelpshiftDelegate> delegate;
}

@property (nonatomic,retain) id<HelpshiftDelegate> delegate;

/** Initialize helpshift support
    
When initializing Helpshift you must pass these three tokens. You initialize Helpshift by adding the following lines in the implementation file for your app delegate, ideally at the top of application:didFinishLaunchingWithOptions
     
    @param appID This is the unique ID assigned to your app
    @param domainName This is your domain name without any http:// or forward slashes
    @param apiKey This is your developer API Key
 
    @available Available in SDK version 1.0.0 or later
*/
+ (void) installForAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey;

+ (Helpshift *) sharedInstance;

/** Show the helpshift support screen
     
To show the Helpshift support screen you need to pass the name of the viewcontroller on which the support screen will show up. For example from inside a viewcontroller you can call Helpshift support by passsing the argument “self”.
     
    @param viewController viewController on which the helpshift support screen will show up.
 
    @available Available in SDK version 1.0.0 or later
*/
- (void) showSupport:(UIViewController *)viewController;

/** Show the helpshift screen to report an issue
 
 To show the Helpshift screen for reporting an issue you need to pass the name of the viewcontroller on which the report issue screen will show up. For example from inside a viewcontroller you can call the Helpshift report issue screen by passsing the argument “self”.
 
 @param viewController viewController on which the helpshift report issue screen will show up.
 
 @available Available in SDK version 1.4.2 or later
*/
- (void) reportIssue:(UIViewController *)viewController;

/** Set the unique identifier for your users.
     
This is part of additional user configuration. You can setup the unique identifier that this user will have with this api.
    @param userIdentifier A unique string to identify your users. For example "user-id-100"
 
    @available Available in SDK version 1.0.0 or later
*/

+ (void) setUserIdentifier:(NSString *)userIdentifier;

/** Set the name of the application user.
    
This is part of additional user configuration. If this is provided through the api, user will not be prompted to re-enter this information again.
     
     @param username The name of the user.
     
     @available Available in SDK version 1.0.0 or later
*/

+ (void) setUsername:(NSString *)username;

/** Set the email-id of the application user.
     
This is part of additional user configuration. If this is provided through the api, user will not be prompted to re-enter this information again.
    
    @param email The email address of the user.
    
    @available Available in SDK version 1.0.0 or later
*/

+ (void) setUseremail:(NSString *)email;

/** Add extra debug information regarding user-actions.
     
You can add additional debugging statements to your code, and see exactly what the user was doing right before they reported the issue.
    
    @param breadCrumbString The string containing any relevant debugging information.
    
    @available Available in SDK version 1.0.0 or later
*/

+ (void) leaveBreadCrumb:(NSString *)breadCrumbString;

/** Get the notification count for replies to reported issues.
 
 
 If you want to show your user notifications for replies on the issues posted, you can get the notification count asynchronously by implementing the HelpshiftDelegate in your respective .h and .m files.
 Use the following method to set the delegate, where self is the object implementing the delegate.
    [[Helpshift sharedInstance] setDelegate:self];
 Now you can call the method
    [[Helpshift sharedInstance] notificationCount];
 This will return a notification count in the
    - (void) notificationCountReceived:(NSString *)
 count delegate method.
 
 @available Available in SDK version 1.0.0 or later
 @warning *Important* This api has been deprecated. Please use notificationCountAsync:(BOOL)isAsync instead.
 */

- (void) notificationCount;

/** Get the notification count for replies to reported issues.
 

If you want to show your user notifications for replies on the issues posted, you can get the notification count asynchronously by implementing the HelpshiftDelegate in your respective .h and .m files.
Use the following method to set the delegate, where self is the object implementing the delegate.
    [[Helpshift sharedInstance] setDelegate:self];
Now you can call the method
    [[Helpshift sharedInstance] notificationCountAsync:true];
This will return a notification count in the
    - (void) notificationCountAsyncReceived:(NSInteger) count
count delegate method.
If you want to retrieve the current notification count synchronously, you can call the same method with the parameter set to false, i.e
    NSInteger count = [[Helpshift sharedInstance] notificationCountAsync:false]

    @param isAsync Whether the notification count is to be returned asynchronously via delegate mechanism or synchronously as a return val for this api
 
    @available Available in SDK version 1.4.4-rc1 or later
*/

- (NSInteger) notificationCountAsync : (BOOL) isAsync;

/** Start a poll for getting notification count of replies to issues posted.
 

If you want to start a background poll for notification counts of replies to posted issues, you can use the below method to start such a poll. You can the polling interval by supplying a parameter to this api. Minimum poll interval is 3 seconds.
Use the following method to set the delegate, where self is the object implementing the delegate.
    [[Helpshift sharedInstance] setDelegate:self];
Now you can call the method
    [[Helpshift sharedInstance] startNotificationCountPolling:pollIntervalInSeconds];
This will return a notification count in the
    - (void) notificationCountReceived:(NSString *)
count delegate method after *pollInterval* number of seconds

    @param pollInterval The number of seconds for notification poll

    @available Available in SDK version 1.4.4-rc1 or later
 */
- (void) startNotificationCountPolling : (NSInteger) pollInterval;

/** Start a poll for getting notification count of replies to issues posted.
 
 
If you want to start a background poll for notification counts of replies to posted issues, you can use the below method to start such a poll. The polling interval will be 10 seconds.
Use the following method to set the delegate, where self is the object implementing the delegate.
    [[Helpshift sharedInstance] setDelegate:self];
Now you can call the method
    [[Helpshift sharedInstance] startNotificationCountPolling]; // poll interval of 10 seconds
This will return a notification count in the
    - (void) notificationCountReceived:(NSString *)
count delegate method after *pollInterval* number of seconds

    @available Available in SDK version 1.4.4-rc1 or later
 */

- (void) startNotificationCountPolling;

/** Stop the notification polling that was previously started with startNotificationCountPolling or startNotificationCountPolling: 
 
If you want to stop polling for notifications to posted issues, call this method.
 
    @available Available in SDK version 1.4.4-rc1 or later

*/
- (void) stopNotificationCountPolling;

/** Register the deviceToken to enable push notifications


To enable push notifications in the Helpshift iOS SDK, set the Push Notifications’ deviceToken using this method inside your application:didRegisterForRemoteNotificationsWithDeviceToken application delegate.
    
    @param deviceToken The deviceToken received from the push notification servers.

Example usage
    - (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:
                (NSData *)deviceToken
    {
        [[Helpshift sharedInstance] registerDeviceToken:deviceToken];
    }
 
    @available Available in SDK version 1.4.0 or later
 
*/
- (void) registerDeviceToken:(NSData *) deviceToken;

/** Forward the push notification for the Helpshift lib to handle


To show support on Notification opened, call handleNotification in your application:didReceiveRemoteNotification application delegate. 
If the value of the “origin” field is “helpshift” call the handleNotification api

    @param notification The dictionary containing the notification information
    @param viewController ViewController on which the helpshift support screen will show up.
    
Example usage
    - (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    {
        if ([[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
            [[Helpshift sharedInstance] handleNotification:userInfo withController:self.viewController];
        }
    }

    @available Available in SDK version 1.4.0 or later
 
*/
- (void) handleNotification: (NSDictionary *)notification withController : (UIViewController *) viewController;
@end

@protocol HelpshiftDelegate <NSObject>
/** Delegate method call that should be implemented if you are calling notificationCount.
 @param count Returns the number of issues with unread messages.
 
 @available Available in SDK version 1.4.0 or later
 @warning *Important* This api has been deprecated. Please use notificationCountAsync : (BOOL) isAsync and implement notificationCountAsyncReceived:(NSInteger)count instead.

 */
- (void) notificationCountReceived:(NSString *)count;

/** Delegate method call that should be implemented if you are calling notificationCountAsync.
    @param count Returns the number of issues with unread messages.
    
    @available Available in SDK version 1.4.4-rc1 or later
*/

- (void) notificationCountAsyncReceived:(NSInteger)count;

/** Optional delegate method that is called when the Helpshift session ends.
 
    @available Available in SDK version 1.4.3 or later
*/
@optional
- (void) helpshiftSessionHasEnded;

@end
