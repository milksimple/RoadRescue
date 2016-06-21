//
//  JXOrderPopView.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrderPopView.h"

@interface JXOrderPopView()
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;

@property (weak, nonatomic) IBOutlet UIImageView *trueView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *knowButton;

@end

@implementation JXOrderPopView

+ (instancetype)popView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    // 设置背景
    [self setupBg];
}

/**
 *  设置背景
 */
- (void)setupBg {
    self.topBgView.image = [JXSkinTool skinToolImageWithImageName:@"order_received_tip_topBg"];
    self.waveBgView.image = [JXSkinTool skinToolImageWithImageName:@"order_received_tip_waveBg"];
    
    self.trueView.image = [JXSkinTool skinToolImageWithImageName:@"order_true"];
    
    self.titleLabel.textColor = self.detailLabel.textColor = [JXSkinTool skinToolColorWithKey:@"order_recevied_tip_title"];
    
    [self.knowButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_next"] forState:UIControlStateNormal];
    [self.knowButton setTitleColor:[JXSkinTool skinToolColorWithKey:@"rescue_next"] forState:UIControlStateNormal];
}

- (IBAction)knowButtonClicked {
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
