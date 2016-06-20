//
//  JXTabBarViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXTabBarViewController.h"
#import "JXTabBar.h"
#import "JXNavigationController.h"
#import "JXOrderManageViewController.h"
#import "JXProfileViewController.h"
#import "JXRescueViewController.h"
#import "JXAccountTool.h"
#import "JXLoginViewController.h"

@interface JXTabBarViewController () <JXTabBarDelegate>

@end

@implementation JXTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. 初始化子控制器
    JXOrderManageViewController *orderManageVC = [[JXOrderManageViewController alloc] init];
    [self addChildVC:orderManageVC image:@"tabbar_order_normal" selectedImage:@"tabbar_order_selected" title:@"订单管理"];
    
    JXProfileViewController *profileVC = [[JXProfileViewController alloc] init];
    [self addChildVC:profileVC image:@"tabbar_profile_normal" selectedImage:@"tabbar_profile_selected" title:@"个人设置"];
    
    // 2.更换系统自带的tabbar
    JXTabBar *tabBar = [[JXTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)addChildVC:(UIViewController *)childVC image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.title = title;
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JXColor(117, 117, 117)} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JXColor(248, 119, 44)} forState:UIControlStateSelected];
    JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:nav];
}

#pragma mark - JXTabBarDelegate
- (void)tabBarDidClickedRescueButton:(JXTabBar *)tabBar {
    JXAccount *account = [JXAccountTool account];
    if (account.telephone.length > 0 && account.token.length > 0) {
        JXRescueViewController *rescueVC = [[JXRescueViewController alloc] init];
        JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:rescueVC];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:nav animated:YES completion:nil];
        });
    }
    else {
        JXLoginViewController *loginVC = [[JXLoginViewController alloc] init];
        JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:loginVC];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:nav animated:YES completion:nil];
        });
    }
}

@end
