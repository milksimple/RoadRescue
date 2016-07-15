//
//  JXNavigationController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXNavigationController.h"
#import "JXRescueDetailViewController.h"
#import "JXRescueViewController.h"

@interface JXNavigationController ()

@end

@implementation JXNavigationController

+ (void)initialize {
    // 获取特定类的所有导航条
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    // 使用自己的图片替换原来的返回图片
    UIImage *navBack = [JXSkinTool skinToolImageWithImageName:@"nav_back"];
    navigationBar.backIndicatorImage = [navBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorTransitionMaskImage = [navBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [navigationBar setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    navigationBar.shadowImage = [UIImage new];
    
    // 设置标题颜色
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:@"navbar_title"]}];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        // 监听修改皮肤的通知
        [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)skinChanged {
    [self.navigationBar setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:@"navbar_title"]}];
    
    // 获取特定类的所有导航条
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    UIImage *navBack = [JXSkinTool skinToolImageWithImageName:@"nav_back"];
    navigationBar.backIndicatorImage = [navBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorTransitionMaskImage = [navBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}

@end
