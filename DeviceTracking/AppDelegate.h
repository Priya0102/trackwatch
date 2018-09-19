//
//  AppDelegate.h
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *deviceToken;
@property (strong,nonatomic) NSString *payload;
@property (strong,nonatomic) NSString *certificate,*badgeValue;
@property(nonatomic,retain)NSString *tag,*success,*error;

@end

