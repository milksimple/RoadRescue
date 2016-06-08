//
//  JXRescueDetailViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#define JXOilNameArray @[@"93#汽油", @"95#汽油"]

#import "JXRescueDetailViewController.h"
#import "JXFeeRingView.h"
#import "JXRescueDetailPopView.h"
#import "EMSDK.h"
#import "JXHttpTool.h"
#import <MJExtension.h>
#import "JXConst.h"
#import "MBProgressHUD+MJ.h"
#import <MBProgressHUD.h>

@interface JXRescueDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, JXRescueDetailPopViewDelegate, JXFeeRingViewDelegate>
@property (weak, nonatomic) IBOutlet JXFeeRingView *feeRingView;
@property (weak, nonatomic) IBOutlet UIPickerView *oilPickerView;
@property (weak, nonatomic) IBOutlet UIImageView *staffView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
/** 救援项目数组, 里面是JXRescueItem对象 */
@property (nonatomic, strong) NSMutableArray *itemList;
/** 救援项目 */
@property (nonatomic, strong) JXRescueItem *rescueItem;
@property (weak, nonatomic) IBOutlet UIView *corverView;

@end

@implementation JXRescueDetailViewController

- (instancetype)initWithOrderDetail:(JXOrderDetail *)orderDetail {
    if (self = [super init]) {
        self.orderDetail = orderDetail;
    }
    return self;
}

#pragma mark - lazy
- (NSMutableArray *)itemList {
    if (_itemList == nil) {
        _itemList = [NSMutableArray array];
        [_itemList addObject:self.rescueItem];
    }
    return _itemList;
}

- (JXRescueItem *)rescueItem {
    if (_rescueItem == nil) {
        _rescueItem = [[JXRescueItem alloc] init];
        _rescueItem.itemType = 1;
    }
    return _rescueItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"救援明细选择";
    self.feeRingView.delegate = self;

    // 标尺图片
    UIImage *staffImg = [JXSkinTool skinToolImageWithImageName:@"rescue_staff"];
//    UIImage *resizableStaffImg = [staffImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.staffView.image = staffImg;
    
    // 设置上下按钮图片
    [self.upButton setImage:[JXSkinTool skinToolImageWithImageName:@"rescue_up_disable"] forState:UIControlStateDisabled];
    [self.upButton setImage:[JXSkinTool skinToolImageWithImageName:@"rescue_up_enable"] forState:UIControlStateNormal];
    [self.downButton setImage:[JXSkinTool skinToolImageWithImageName:@"rescue_down_disable"] forState:UIControlStateDisabled];
    [self.downButton setImage:[JXSkinTool skinToolImageWithImageName:@"rescue_down_enable"] forState:UIControlStateNormal];
    
    // 设置slider图片
    UIImage *sliderBg = [[JXSkinTool skinToolImageWithImageName:@"rescue_slider_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
    [self.slider setMaximumTrackImage:sliderBg forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:sliderBg forState:UIControlStateNormal];
    
    [self.slider setThumbImage:[JXSkinTool skinToolImageWithImageName:@"rescue_slider_thumb"] forState:UIControlStateNormal];
    
    // 请求今日油价
    [self loadOilPrice];
}

- (void)loadOilPrice {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在获取今日油价" toView:self.feeRingView];
    hud.dimBackground = NO;
    hud.color = [UIColor whiteColor];
    hud.activityIndicatorColor = [UIColor grayColor];
    hud.labelColor = [UIColor grayColor];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
#warning 测试，还没有公式，仅测下接口
    paras[@"moblie"] = @"13888650223";
    paras[@"token"] = @"7F9D459A";
    paras[@"itemType"] = @(self.orderDetail.itemTypes);
    
    JXLog(@"loadOilPrice - paras = %@", paras);
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/orderFee", JXServerName] params:paras success:^(id json) {
        JXLog(@"请求成功 - %@", json);
        [MBProgressHUD hideHUDForView:self.feeRingView];
        self.feeRingView.loadSuccess = YES;
        self.corverView.userInteractionEnabled = NO;
        
    } failure:^(NSError *error) {
        JXLog(@"请求失败 - %@", error);
        [MBProgressHUD hideHUDForView:self.feeRingView];
        
        self.feeRingView.loadSuccess = NO;
    }];
}

- (IBAction)upButtonClicked:(UIButton *)upButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] - 1;
//    if (selectedRow == 0) {
//        upButton.enabled = NO;
//    }
//    else {
//        upButton.enabled = YES;
//    }
//    if (selectedRow != 3) {
//        self.downButton.enabled = YES;
//    }

    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
    [self pickerView:self.oilPickerView didSelectRow:selectedRow inComponent:0];
}

- (IBAction)downButtonClicked:(UIButton *)downButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] + 1;
//    if (selectedRow == 3) {
//        downButton.enabled = NO;
//    }
//    else {
//        downButton.enabled = YES;
//    }
//    if (selectedRow != 0) {
//        self.upButton.enabled = YES;
//    }

    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
    [self pickerView:self.oilPickerView didSelectRow:selectedRow inComponent:0];
}

/*
 {
 
 itemList: 救援项目[
 {
 itemType: 项目类型<1-燃油耗尽>,
 itemClass: 项目类别(itemType为1时)<0-柴油,93-汽油,97-汽油>,
 itemCnt: 份数,
 itemPrice: 项目总金额,
 subsidy: 补贴金额,
 giftMoney: 红包金额
 }
 ],
 
 }
 */

- (IBAction)sliderValueChanged:(UISlider *)slider {
    NSInteger itemCnt = (NSInteger)(slider.value);
    self.rescueItem.itemCnt = itemCnt;
    
    CGFloat fareFee = 50;
    CGFloat totalPrice = 5.57 * itemCnt + fareFee;
    CGFloat redBagFee = totalPrice * 0.1;
    CGFloat allowanceFee = totalPrice * 0.15;
    CGFloat actuallyPay = totalPrice - redBagFee - allowanceFee - fareFee;
    
    if (itemCnt >= 10) {
        self.feeRingView.freeFare = YES;
    }
    else {
        self.feeRingView.freeFare = NO;
    }
    self.feeRingView.totalPrice = totalPrice;
    self.feeRingView.redBagFee = redBagFee;
    self.feeRingView.allowanceFee = allowanceFee;
    self.feeRingView.fareFee = fareFee;
    self.feeRingView.actuallyPay = actuallyPay;
    
    self.rescueItem.itemPrice = totalPrice;
    self.rescueItem.subsidy = allowanceFee;
    self.rescueItem.giftMoney = redBagFee;
    
    self.orderDetail.totalPrice = totalPrice;
}

- (IBAction)rescueRequestButtonClicked {
    self.orderDetail.itemList = self.itemList;
    
    JXRescueItem *item = self.itemList[0];
    JXLog(@"item.itemClass= %zd", item.itemClass);
    JXLog(@"self.itemClass = %zd", self.rescueItem.itemClass);
    
    JXRescueDetailPopView *rescueDetailPopView = [JXRescueDetailPopView popView];
    rescueDetailPopView.orderDetail = self.orderDetail;
    rescueDetailPopView.delegate = self;
    [rescueDetailPopView show];
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *oilLabel = [[UILabel alloc] init];
    oilLabel.font = [UIFont systemFontOfSize:13];
    oilLabel.textAlignment = NSTextAlignmentCenter;
    switch (row) {
        case 0:
            oilLabel.text = @"柴油";
            break;
            
        case 1:
            oilLabel.text = @"93#汽油";
            break;
            
        case 2:
            oilLabel.text = @"97#汽油";
            break;
    }
    return oilLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.upButton.enabled = NO;
    }
    else {
        self.upButton.enabled = YES;
    }
    if (row == 3) {
        self.downButton.enabled = NO;
    }
    else {
        self.downButton.enabled = YES;
    }
    
    switch (row) {
        case 0:
            self.rescueItem.itemClass = 0;
            // 可能要在此处切换油价，重新计算费用
            break;
            
        case 1:
            self.rescueItem.itemClass = 93;
            break;
            
        case 2:
            self.rescueItem.itemClass = 97;
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - JXRescueDetailPopViewDelegate
- (void)rescueDetailPopViewDidClickedConfirmButton {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在提交订单"];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // 发送请求
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
#warning 测试
    paras[@"moblie"] = @"13888650223";
    paras[@"token"] = @"7F9D459A";
    NSDictionary *orderDic = [self.orderDetail mj_keyValues];
    NSData *orderData = [NSJSONSerialization dataWithJSONObject:orderDic options:0 error:nil];
    NSString *orderStr = [[NSString alloc] initWithData:orderData encoding:NSUTF8StringEncoding];
    paras[@"order"] = orderStr;
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/addOrder", JXServerName] params:paras success:^(id json) {
        [MBProgressHUD hideHUD];
        JXLog(@"提交订单请求成功 - %@", json);
        
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            [MBProgressHUD showSuccess:@"提交订单成功!"];
            [self dismissViewControllerAnimated:YES completion:^{
                // 1.发送通知，下订单成功
                // 赋值订单号
                self.orderDetail.orderNum = json[@"data"][@"orderNum"];
                [JXNotificationCenter postNotificationName:JXPlaceAnOrderNotification object:nil userInfo:@{JXNewOrderDetailKey:self.orderDetail}];
                
                
                // 2. 发送消息，通知救援队
#warning 测试
                // 发送透传消息
                //    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"下单"];
                //    NSString *from = [[EMClient sharedClient] currentUsername];
                //
                //    // 生成message
                //    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"6001" from:from to:@"oiler001" body:body ext:nil];
                //    message.chatType = EMChatTypeChat; // 设置为单聊消息
                //
                //    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                //        if (!error) { // 发送成功
                //            JXLog(@"用户发送消息成功 == 下单成功");
                //        }
                //    }];
                
                // 发送文本消息
                EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"下单"];
                NSString *from = [[EMClient sharedClient] currentUsername];
                
                //生成Message
                EMMessage *message = [[EMMessage alloc] initWithConversationID:@"oiler001" from:from to:@"oiler001" body:body ext:nil];
                message.chatType = EMChatTypeChat;
                
                [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                    if (!error) { // 发送成功
                        JXLog(@"用户发送消息成功 == 下单成功");
                    }
                }];

            }];
        }
    } failure:^(NSError *error) {
        JXLog(@"请求失败 - %@", error);
        [MBProgressHUD hideHUD];

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"订单提交失败" message:@"请检查网络后重新提交订单" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }];

}

#pragma mark - JXFeeRingViewDelegate
- (void)feeRingViewDidClickedReloadButton {
    [self loadOilPrice];
}

@end
