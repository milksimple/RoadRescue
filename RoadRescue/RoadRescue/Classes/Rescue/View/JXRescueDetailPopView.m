//
//  JXRescueDetailPopView.m
//  RoadRescue
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueDetailPopView.h"

@interface JXRescueDetailPopView()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIView *oilItemContainer;
@property (weak, nonatomic) IBOutlet UIView *fixItemContainer;
@property (weak, nonatomic) IBOutlet UIView *totalPriceItemContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalToOilContainerConstraint;

@end

@implementation JXRescueDetailPopView

+ (instancetype)popView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    UIImage *closeImg = [JXSkinTool skinToolImageWithImageName:@"rescue_close"];
    [self.closeButton setImage:closeImg forState:UIControlStateNormal];
    
    // 隐藏维修项目
    self.totalToOilContainerConstraint.constant = 0;
    self.fixItemContainer.hidden = YES;
}

- (IBAction)closeButtonClicked {
    [self dismiss];
}

- (IBAction)confirmButtonClicked {
    [self dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
