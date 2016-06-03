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

@interface JXRescueDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
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
    
//    self.feeRingView.totalPrice = 2600;
//    self.feeRingView.redBagPercentage = 0.1;
//    self.feeRingView.allowancePercentage = 0.2;
//    self.feeRingView.fareFee = 0.05;
//    self.feeRingView.actuallyPaidPercentage = 0.65;
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
    
}

- (IBAction)upButtonClicked:(UIButton *)upButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] - 1;
    if (selectedRow == 0) {
        upButton.enabled = NO;
    }
    else {
        upButton.enabled = YES;
    }
    if (selectedRow != 3) {
        self.downButton.enabled = YES;
    }

    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
}

- (IBAction)downButtonClicked:(UIButton *)downButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] + 1;
    if (selectedRow == 3) {
        downButton.enabled = NO;
    }
    else {
        downButton.enabled = YES;
    }
    if (selectedRow != 0) {
        self.upButton.enabled = YES;
    }

    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
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
    
    CGFloat totalPrice = 5.57 * itemCnt;
    CGFloat redBagFee = totalPrice * 0.1;
    CGFloat allowanceFee = totalPrice * 0.15;
    CGFloat fareFee = 50;
    CGFloat actuallyPay = totalPrice - redBagFee - allowanceFee + fareFee;
    
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
    JXLog(@"self.orderDetail = %@", self.orderDetail);
    self.orderDetail.itemList = self.itemList;
    // 发送请求
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"moblie"] = @"13888650223";
    paras[@"token"] = @"7F9D459A";
    NSDictionary *orderDic = [self.orderDetail mj_keyValues];
    NSData *orderData = [NSJSONSerialization dataWithJSONObject:orderDic options:0 error:nil];
    NSString *orderStr = [[NSString alloc] initWithData:orderData encoding:NSUTF8StringEncoding];
    paras[@"order"] = orderStr;
    JXLog(@"orderStr = %@", orderStr);
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/addOrder", JXServerName] params:paras success:^(id json) {
        JXLog(@"请求成功 - %@", json);
    } failure:^(NSError *error) {
        JXLog(@"请求失败 - %@", error);
    }];
    
    JXRescueDetailPopView *rescueDetailPopView = [JXRescueDetailPopView popView];
    [rescueDetailPopView show];
    
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

@end
