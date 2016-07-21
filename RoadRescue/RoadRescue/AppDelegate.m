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
#import "JXRescueDetailViewController.h"
#import "JXAccountTool.h"
#import "UIWindow+Extension.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate ()

/** 账号信息 */
@property (nonatomic, strong) JXAccount *account;

@end

@implementation AppDelegate
#pragma mark - lazy
- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupIQKeyboardManager];
    
    // 初始化环信IM
    [self setupEMIM];
    
    // 注册APNS
    [self setupAPNSWithApplication:application];
    
    // 初始化SMSSDK
    [SMSSDK registerApp:@"14badd10983f4" withSecret:@"b425dce15cfbe46615e720bfa96f406e"];
    
    // 初始化高德SDK
    [self configureGaoDeAPIKey];
    
    // badge置0
    if (JXApplication.applicationIconBadgeNumber != 0) {
        [JXApplication setApplicationIconBadgeNumber:0];
    }
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    // 自动选择加载rootViewController
    [self.window switchRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *  初始化智能键盘
 */
- (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboard = [IQKeyboardManager sharedManager];
    keyboard.toolbarDoneBarButtonItemText = @"完成";
    [keyboard disableToolbarInViewControllerClass:[JXRescueDetailViewController class]];
    keyboard.toolbarTintColor = [UIColor grayColor];
    keyboard.enable = YES;
}

- (void)setupEMIM {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"limit#succor"];
    options.apnsCertName = @"roadRescuePushDevelop";
    [[EMClient sharedClient] initializeSDKWithOptions:options];

    // 登录环信
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin && self.account.telephone.length > 0) {
        [[EMClient sharedClient] asyncLoginWithUsername:[NSString stringWithFormat:@"%@_user", self.account.telephone] password:@"123456" success:^{
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
            options.displayStyle = EMPushDisplayStyleMessageSummary;
            [[EMClient sharedClient] updatePushOptionsToServer];
        } failure:^(EMError *aError) {
            JXLog(@"setupEMIM - IM登录失败");
        }];
    }
}

- (void)configureGaoDeAPIKey
{
    
    [AMapServices sharedServices].apiKey = (NSString *)JXGaoDeAPIKey;
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    JXLog(@"error -- %@",error);
}

@end
