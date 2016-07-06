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
        self.backgroundImage = [JXSkinTool skinToolImageWithImageName:@"tabbar_bg"];
        self.shadowImage = [UIImage new];
        
        // 监听修改皮肤的通知
        [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
    }
    return self;
}

- (void)skinChanged {
    self.backgroundImage = [JXSkinTool skinToolImageWithImageName:@"tabbar_bg"];
    
    [self.rescueButton setImage:[JXSkinTool skinToolImageWithImageName:@"tabbar_rescue"] forState:UIControlStateNormal];
}

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
        UIImage *rescueImg = [JXSkinTool skinToolImageWithImageName:@"tabbar_rescue"];
        [rescueButton setImage:rescueImg forState:UIControlStateNormal];
        rescueButton.jx_size = rescueImg.size;
        
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
        
        Class bgImgClass = NSClassFromString(@"_UITabBarBackgroundView");
        if ([child isKindOfClass:bgImgClass]) {
            UIImageView *bgView = (UIImageView *)child;
            bgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}

@end
