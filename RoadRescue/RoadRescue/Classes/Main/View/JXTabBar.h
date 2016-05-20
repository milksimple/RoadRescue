//
//  JXTabBar.h
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXTabBar;


@protocol JXTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickedRescueButton:(JXTabBar *)tabBar;

@end

@interface JXTabBar : UITabBar

@property (nonatomic, weak) id<JXTabBarDelegate> delegate;

@end
