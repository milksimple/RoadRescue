//
//  JXLoadTipView.m
//  Fellow
//
//  Created by mac on 16/3/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXLoadTipView.h"
#import "UIView+JXExtension.h"

@interface JXLoadTipView()
@property (weak, nonatomic) IBOutlet UILabel *tipTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation JXLoadTipView

+ (instancetype)loadTipView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
+ (instancetype)loadTipViewWithType:(JXLoadTipViewType)type {
    JXLoadTipView *tipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    tipView.type = type;
    return tipView;
}

- (IBAction)reloadButtonClicked {
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(loadTipViewDidClickedReloadButton)]) {
        [self.delegate loadTipViewDidClickedReloadButton];
    }
    
    [self dismiss];
}

- (void)setType:(JXLoadTipViewType)type {
    _type = type;
    
    self.reloadButton.hidden = type;
}

- (void)setTipTitle:(NSString *)tipTitle {
    _tipTitle = tipTitle;
    
    self.tipTitleLabel.text = tipTitle;
}

/**
 *  显示重新加载提示页面
 */
- (void)showTipViewToView:(UIView *)toView {
    CGFloat tipW = 150;
    CGFloat tipH = 150;
    CGFloat tipX = (toView.jx_width - tipW) * 0.5;
    
    CGFloat tipY = (toView.jx_height - tipH) * 0.5;
    
    self.frame = CGRectMake(tipX, tipY, tipW, tipH);
    
    [toView addSubview:self];
}

/**
 *  显示重新加载提示页面
 *
 *  @param toView 要显示的页面
 *  @param bottom 希望tipview距离底部的距离
 */
- (void)showTipViewToView:(UIView *)toView bottom:(CGFloat)bottom {
    CGFloat tipW = 150;
    CGFloat tipH = 150;
    CGFloat tipX = (toView.jx_width - tipW) * 0.5;
    
    CGFloat tipY = (toView.jx_height - tipH) - bottom;
    
    self.frame = CGRectMake(tipX, tipY, tipW, tipH);
    
    [toView addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
