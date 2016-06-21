//
//  JXMyOrderCompletePopView.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXMyOrderCompletePopView.h"

@interface JXMyOrderCompletePopView()

@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *trueView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation JXMyOrderCompletePopView

+ (instancetype)completePopView {
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
    
    self.trueView.image = [JXSkinTool skinToolImageWithImageName:@"order_card"];
    
    self.titleLabel.textColor = self.detailLabel.textColor = [JXSkinTool skinToolColorWithKey:@"order_recevied_tip_title"];
    
    [self.confirmButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_next"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[JXSkinTool skinToolColorWithKey:@"rescue_next"] forState:UIControlStateNormal];
    
    [self.closeButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_close"] forState:UIControlStateNormal];
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

- (IBAction)closeButtonClicked {
    [self dismiss];
}

@end
