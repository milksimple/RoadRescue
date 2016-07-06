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
#import "EMSDK.h"

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
    
//    // 查看自己是否在救援队的群组
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = nil;
//        NSArray *groups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
//        for (EMGroup *group in groups) {
//            JXLog(@"本用户所在的救援队群 - %@", group.groupId);
//            // 退出该群,避免收到其他司机发来的新订单push通知
//            EMError *error = nil;
//            [[EMClient sharedClient].groupManager leaveGroup:group.groupId error:&error];
//        }
//    });
    
    // 监听修改皮肤的通知
    [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
}

- (void)addChildVC:(UIViewController *)childVC image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    childVC.tabBarItem.image = [JXSkinTool skinToolImageWithImageName:image];
    childVC.tabBarItem.selectedImage = [[JXSkinTool skinToolImageWithImageName:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.title = title;
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:@"tabbar_item_title_normal"]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:@"tabbar_item_title_selected"]} forState:UIControlStateSelected];
    JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:nav];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self skinChanged];
//}

#pragma mark - JXTabBarDelegate
- (void)tabBarDidClickedRescueButton:(JXTabBar *)tabBar {
//#warning 测试
//    JXRescueViewController *rescueVC = [[JXRescueViewController alloc] init];
//    JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:rescueVC];
//    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentViewController:nav animated:YES completion:nil];
//    });
//    
//    return;
    
    JXAccount *account = [JXAccountTool account];
    if (account.telephone.length > 0 && account.token.length > 0) {
        JXRescueViewController *rescueVC = [[JXRescueViewController alloc] init];
        JXNavigationController *nav = [[JXNavigationController alloc] initWithRootViewController:rescueVC];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
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

- (void)skinChanged {
    JXOrderManageViewController *orderManageVC = self.childViewControllers[0];
    [self setChildVC:orderManageVC tabBarItemImage:@"tabbar_order_normal" selectedImage:@"tabbar_order_selected" titleColor:@"tabbar_item_title_normal" selectedTitleColor:@"tabbar_item_title_selected"];
    
    JXProfileViewController *profileVC = self.childViewControllers[1];
    [self setChildVC:profileVC tabBarItemImage:@"tabbar_profile_normal" selectedImage:@"tabbar_profile_selected" titleColor:@"tabbar_item_title_normal" selectedTitleColor:@"tabbar_item_title_selected"];
}

- (void)setChildVC:(UIViewController *)childVC tabBarItemImage:(NSString *)image selectedImage:(NSString *)selectedImage titleColor:(NSString *)titleColor selectedTitleColor:(NSString *)selectedTitleColor {
    childVC.tabBarItem.image = [JXSkinTool skinToolImageWithImageName:image];
    childVC.tabBarItem.selectedImage = [[JXSkinTool skinToolImageWithImageName:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:titleColor]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[JXSkinTool skinToolColorWithKey:selectedTitleColor]} forState:UIControlStateSelected];
}

- (void)dealloc {
    JXLog(@"tabbarVC - dealloc");
    [JXNotificationCenter removeObserver:self];
}

@end
