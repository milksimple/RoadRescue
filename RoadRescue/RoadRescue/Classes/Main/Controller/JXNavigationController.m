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
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
