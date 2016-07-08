//
//  JXMyOrderCompletePopView.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXMyOrderCompletePopView.h"
#import "JXOrderDetail.h"
#import "JXHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "JXAccountTool.h"

@interface JXMyOrderCompletePopView()

@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *trueView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (nonatomic, strong) JXAccount *account;
@end

@implementation JXMyOrderCompletePopView
#pragma mark - lazy
- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

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
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"" toView:self];
    hud.mode = MBProgressHUDModeIndeterminate;
    // 通知服务器订单完成
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"orderNum"] = self.orderDetail.orderNum;
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/finishOrder", JXServerName] params:paras success:^(id json) {
        JXLog(@"请求完成订单成功 - %@", json);
        
        [MBProgressHUD hideHUDForView:self];
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            [MBProgressHUD showSuccess:@"订单完成！"];
            [self dismiss];
        }
        else {
            [MBProgressHUD showError:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self];
        [MBProgressHUD showError:@"网络连接失败"];
        JXLog(@"请求完成订单失败 - %@", error);
    }];
    
}

- (void)setOrderDetail:(JXOrderDetail *)orderDetail {
    _orderDetail = orderDetail;
    
    self.titleLabel.text = orderDetail.title;
    JXLog(@"orderDetail.title = %@", orderDetail.title);
    self.feeLabel.text = [NSString stringWithFormat:@"¥%.2f", orderDetail.totalPrice];
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

- (IBAction)contactButtonClicked {
    // 拨打电话按钮被点击
    NSString *str= [NSString stringWithFormat:@"tel:%@", self.orderDetail.mobile];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}

@end
