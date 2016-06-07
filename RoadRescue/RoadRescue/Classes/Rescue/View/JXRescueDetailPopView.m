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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oilContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceContainerConstraint;

@property (weak, nonatomic) IBOutlet UILabel *addressShortLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDesLabel;
@property (weak, nonatomic) IBOutlet JXVerticalButton *oilButton;
@property (weak, nonatomic) IBOutlet JXVerticalButton *fixButton;
@property (weak, nonatomic) IBOutlet UILabel *oilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

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
    self.totalPriceContainerConstraint.constant = 0;
    self.fixItemContainer.hidden = YES;
}

- (void)setOrderDetail:(JXOrderDetail *)orderDetail {
    _orderDetail = orderDetail;
    
    switch (orderDetail.itemTypes) {
        case 1: // 油料救援
            self.totalPriceContainerConstraint.constant = 40;
            self.fixItemContainer.hidden = YES;
            
            self.oilButton.selected = YES;
            self.fixButton.selected = NO;
            break;
            
        case 2: // 简易维修
            self.fixContainerConstraint.constant = 10;
            self.totalPriceContainerConstraint.constant = 40;
            self.oilItemContainer.hidden = YES;
            
            self.oilButton.selected = NO;
            self.fixButton.selected = YES;
            break;
            
        case 3: // 油料救援 + 简易维修
            self.oilButton.selected = YES;
            self.fixButton.selected = YES;
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
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%f", orderDetail.totalPrice];
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

@end
