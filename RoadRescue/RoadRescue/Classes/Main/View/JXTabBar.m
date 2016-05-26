//
//  JXTabBar.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXTabBar.h"
#import "UIView+JXExtension.h"

@interface JXTabBar()

@property (nonatomic, weak) UIButton *rescueButton;

@end

@implementation JXTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

//- (void)setup {
//    UIButton *rescueButton = [[UIButton alloc] init];
//    [rescueButton setImage:[UIImage imageNamed:@"tabbar_rescue"] forState:UIControlStateNormal];
//    rescueButton.jx_size = [UIImage imageNamed:@"tabbar_rescue"].size;
//    
//    [rescueButton addTarget:self action:@selector(rescueButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:rescueButton];
//    self.rescueButton = rescueButton;
//}

- (void)rescueButtonDidClicked {
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedRescueButton:)]) {
        [self.delegate tabBarDidClickedRescueButton:self];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point) || CGRectContainsPoint(self.rescueButton.frame, point)) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.rescueButton == nil) {
        UIButton *rescueButton = [[UIButton alloc] init];
        [rescueButton setImage:[UIImage imageNamed:@"tabbar_rescue"] forState:UIControlStateNormal];
        rescueButton.jx_size = [UIImage imageNamed:@"tabbar_rescue"].size;
        
        [rescueButton addTarget:self action:@selector(rescueButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rescueButton];
        self.rescueButton = rescueButton;
    }
    
    // 1.设置加号按钮的位置
    self.rescueButton.jx_centerX = self.jx_width * 0.5;
    self.rescueButton.jx_centerY = self.jx_height * 0.3;
    
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.jx_width / 3;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.jx_width = tabbarButtonW;
            // 设置x
            child.jx_x = tabbarButtonIndex * tabbarButtonW;
            
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 1) {
                tabbarButtonIndex++;
            }
        }
        
//        if (child.jx_height == 0.5) {
//            child.hidden = YES;
//        }
    }
}

@end
