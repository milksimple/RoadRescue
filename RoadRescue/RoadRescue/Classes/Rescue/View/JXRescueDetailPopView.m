//
//  JXRescueDetailPopView.m
//  RoadRescue
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueDetailPopView.h"
#import "JXVerticalButton.h"
#import "JXOrderDetail.h"
#import "JXRescueItem.h"

@interface JXRescueDetailPopView()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIView *oilItemContainer;
@property (weak, nonatomic) IBOutlet UIView *fixItemContainer;
@property (weak, nonatomic) IBOutlet UIView *totalPriceItemContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oilButtonWidthCst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixButtonWidthCst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oilContrainerHeightCst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixContainerHeightCst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceContainerHeightCst;

@property (weak, nonatomic) IBOutlet UILabel *addressShortLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDesLabel;
@property (weak, nonatomic) IBOutlet JXVerticalButton *oilButton;
@property (weak, nonatomic) IBOutlet JXVerticalButton *fixButton;
@property (weak, nonatomic) IBOutlet UILabel *oilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;

@property (weak, nonatomic) IBOutlet UIImageView *locationView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation JXRescueDetailPopView

+ (instancetype)popView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    // 设置背景
    [self setupBg];
}

- (void)setupBg {
    // 位置
    self.locationView.image = [JXSkinTool skinToolImageWithImageName:@"location"];
    
    // 关闭按钮
    [self.closeButton setImage:[JXSkinTool skinToolImageWithImageName:@"rescue_close"] forState:UIControlStateNormal];
    
    self.topBgView.image = [JXSkinTool skinToolImageWithImageName:@"rescue_pop_topBg"];
    self.waveBgView.image = [JXSkinTool skinToolImageWithImageName:@"rescue_pop_waveBg"];
    
    // 确定按钮
    [self.confirmButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_next"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[JXSkinTool skinToolColorWithKey:@"rescue_next"] forState:UIControlStateNormal];
    
}

- (void)setOrderDetail:(JXOrderDetail *)orderDetail {
    _orderDetail = orderDetail;
    
    switch (orderDetail.itemTypes) {
        case 1: // 油料救援
            self.fixButtonWidthCst.constant = 0;
            self.fixContainerHeightCst.constant = 0;
            break;
            
        case 2: // 简易维修
            self.oilButtonWidthCst.constant = 0;
            self.oilContrainerHeightCst.constant = 0;
            break;
            
        case 3: // 油料救援 + 简易维修
            break;
            
        default:
            break;
    }
    
    self.addressShortLabel.text = orderDetail.addressShort;
    self.addressDesLabel.text = orderDetail.addressDes;
    
    // 显示油料名称
    if (orderDetail.itemTypes == 1 || orderDetail.itemTypes == 3) {
        JXRescueItem *rescueItem = orderDetail.itemList.firstObject;
        self.oilCountLabel.text = [NSString stringWithFormat:@"%zdL", rescueItem.itemCnt];
        switch (rescueItem.itemClass) {
            case 0: // 柴油
                self.oilNameLabel.text = @"柴油";
                break;
                
            case 93:
                self.oilNameLabel.text = @"93#汽油";
                break;
                
            case 97:
                self.oilNameLabel.text = @"97#汽油";
                break;
                
            default:
                break;
        }
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", orderDetail.totalPrice];
}

- (IBAction)closeButtonClicked {
    [self dismiss];
}

- (IBAction)confirmButtonClicked {
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(rescueDetailPopViewDidClickedConfirmButton)]) {
        [self.delegate rescueDetailPopViewDidClickedConfirmButton];
    }
    
    [self dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    
}

@end
