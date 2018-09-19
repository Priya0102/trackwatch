//  AppDelegate.m
//  DeviceTracking

//AIzaSyDRTMcRx0pYYCY30busy5QttddC14KMIn0  //OLD api kEY //10 sep
//AIzaSyAtXKs6fKCtetaG2FPWTxKIuf7UfhhVLhY //NEW api kEY //14 Sep 2018
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "Firebase.h"
#import <unistd.h>
#import "SignInViewController.h"
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UIKit;
@import UserNotifications;
#endif

@import Firebase;
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad
@end

@implementation AppDelegate
NSString *const kGCMMessageIDKey = @"gcm.message_id";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    sleep(3);

    [FIRApp configure];
    [FIRMessaging messaging].delegate=self;
    application.applicationIconBadgeNumber = 0;
    
    [GMSServices provideAPIKey:@"AIzaSyAtXKs6fKCtetaG2FPWTxKIuf7UfhhVLhY"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyAtXKs6fKCtetaG2FPWTxKIuf7UfhhVLhY"];
    
    // Define some colors.
    UIColor *darkGray = [UIColor darkGrayColor];
    UIColor *lightGray = [UIColor lightGrayColor];
    
    // Navigation bar background.
    [[UINavigationBar appearance] setBarTintColor:darkGray];
    [[UINavigationBar appearance] setTintColor:lightGray];
    
    // Color of typed text in the search bar.
    NSDictionary *searchBarTextAttributes = @{
                                              NSForegroundColorAttributeName: lightGray,
                                              NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                              };
    [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
    .defaultTextAttributes = searchBarTextAttributes;
    
    // Color of the placeholder text in the search bar prior to text entry.
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: lightGray,
                                            NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                            };
    
    // Color of the default search text.
    // NOTE: In a production scenario, "Search" would be a localized string.
    NSAttributedString *attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Search"
                                    attributes:placeholderAttributes];
    [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
    .attributedPlaceholder = attributedPlaceholder;
    
    // Color of the in-progress spinner.
    [[UIActivityIndicatorView appearance] setColor:lightGray];
    
    // To style the two image icons in the search bar (the magnifying glass
    // icon and the 'clear text' icon), replace them with different images.
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_clear_x_high"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateHighlighted];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_clear_x"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_search"]
                      forSearchBarIcon:UISearchBarIconSearch
                                 state:UIControlStateNormal];
    
    // Color of selected table cells.
//    UIView *selectedBackgroundView = [[UIView alloc] init];
//    selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
//    [UITableViewCell appearanceWhenContainedIn:[GMSAutocompleteViewController class], nil]
//    .selectedBackgroundView = selectedBackgroundView;
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    
    UIStoryboard *storyboard = [self grabStoryboard];
    
    // display storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    
    if(savedValue!=NULL)
    {
        int screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        
        switch (screenHeight) {
                // iPhone 4s
            case 480:
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                
                break;
            }
                //iPhone 5 & iPhone SE
            case 548:
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                
                break;
            }
                // iPhone 5s
            case 568:
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                
                break;
            }
                // iPhone 6 & 6s & iPhone 7
            case 647:
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                
                break;
            }
            case 812://iPhone X
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main3" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main3" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                break;
            }
            default:
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:nil];
                SignInViewController *loginController=[[UIStoryboard storyboardWithName:@"Main2" bundle:nil]instantiateViewControllerWithIdentifier:@"identifier"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
                self.window.rootViewController = navController;
                
                break;
            }
                
        }
    }
    
    return YES;
}
- (UIStoryboard *)grabStoryboard {
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"screenheight==== %d",screenHeight);
    UIStoryboard *storyboard;
    
    switch (screenHeight) {
            // iPhone 4s
        case 480:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            //iPhone 5 & iPhone SE
        case 548:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 5s
        case 568:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 6 & 6s & iPhone 7
        case 647:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
        case 812://iphone X
            storyboard = [UIStoryboard storyboardWithName:@"Main3" bundle:nil];
            break;
            
            
        default:
            
            storyboard = [UIStoryboard storyboardWithName:@"Main2" bundle:nil];
            break;
            
    }
    
    return storyboard;
}

- (void)renumberBadgesOfPendingNotifications
{
    // clear the badge on the icon
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // first get a copy of all pending notifications (unfortunately you cannot 'modify' a pending notification)
    NSArray *pendingNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // if there are any pending notifications -> adjust their badge number
    if (pendingNotifications.count != 0)
    {
        // clear all pending notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // the for loop will 'restore' the pending notifications, but with corrected badge numbers
        // note : a more advanced method could 'sort' the notifications first !!!
        NSUInteger badgeNbr = 1;
        
        for (UILocalNotification *notification in pendingNotifications)
        {
            // modify the badgeNumber
            notification.applicationIconBadgeNumber = badgeNbr++;
            
            // schedule 'again'
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
/* handl to open app when clicked on push notification*/
/*-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if(application.applicationState == UIApplicationStateActive) {
        
        //app is currently active, can update badges count here
        
    } else if(application.applicationState == UIApplicationStateBackground){
        
        //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        
    } else if(application.applicationState == UIApplicationStateInactive){
        
        //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController = // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
    }
    
}*/
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"recieve new FCM registration token: %@", fcmToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:@"fcmToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    
}

#endif
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    
    NSLog(@"****FCM registration token: %@", fcmToken);
    // TODO: If necessary send token to application server.
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}

// [END ios_10_data_message]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;//added
    
    // Prepare the Device Token for Registration (remove spaces and < >)     NSString *devToken = [[[[deviceToken description]          stringByReplacingOccurrencesOfString:@"<"withString:@""]          stringByReplacingOccurrencesOfString:@">" withString:@""]          stringByReplacingOccurrencesOfString: @" " withString: @""];      NSLog(@"My token is: %@", devToken);
    
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    NSString *deviceTokenString=[deviceToken description];
    deviceTokenString=[deviceTokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSString *str=[deviceTokenString stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0,[deviceTokenString length])];
    NSLog(@"str==%@",str);
    
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"***deviceid***** = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]);
    
    // With swizzling disabled you must set the APNs device token here.
    // [Messaging messaging].APNSToken = deviceToken;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end
