//
//  AppDelegate.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "JXTabBarViewController.h"
#import <IQKeyboardManager.h>
#import "EMSDK.h"
#import "SMS_SDK/SMSSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupIQKeyboardManager];
    
    // 初始化环信IM
    [self setupEMIM];
    
    // 注册APNS
    [self setupAPNSWithApplication:application];
    
    // 初始化SMSSDK
    [SMSSDK registerApp:@"13a02edfba956" withSecret:@"7e7bd94a0bc0065dcb7b1c39fb20f976"];
    
    // badge置0
    if (JXApplication.applicationIconBadgeNumber != 0) {
        [JXApplication setApplicationIconBadgeNumber:0];
    }
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[JXTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *  初始化智能键盘
 */
- (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboard = [IQKeyboardManager sharedManager];
    keyboard.toolbarDoneBarButtonItemText = @"完成";
    keyboard.toolbarTintColor = [UIColor grayColor];
    keyboard.enable = YES;
}


- (void)setupEMIM {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"jimaoxin001#oil"];
    options.apnsCertName = @"roadRescuePushDevelop";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
#warning 测试登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:@"oil001" password:@"111111"];
        if (!error) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
    
}

- (void)setupAPNSWithApplication:(UIApplication *)application {
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    // badge置0
    if (JXApplication.applicationIconBadgeNumber != 0) {
        [JXApplication setApplicationIconBadgeNumber:0];
    }
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    JXLog(@"error -- %@",error);
}

@end
