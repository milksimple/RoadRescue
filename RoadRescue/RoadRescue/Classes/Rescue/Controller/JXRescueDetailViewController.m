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
#import "JXAccountTool.h"
#import "JXRescueItem.h"

@interface JXRescueDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, JXRescueDetailPopViewDelegate, JXFeeRingViewDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet JXFeeRingView *feeRingView;
@property (weak, nonatomic) IBOutlet UIPickerView *oilPickerView;
@property (weak, nonatomic) IBOutlet UIImageView *staffView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
/** 救援项目数组, 里面是JXRescueItem对象, 之所以是数组是因为将来可能有维修 */
@property (nonatomic, strong) NSMutableArray *itemList;
/** 救援项目，目前只表示燃油耗尽 */
//@property (nonatomic, strong) JXRescueItem *rescueItem;
@property (weak, nonatomic) IBOutlet UIView *corverView;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *todayPriceContainer;
@property (weak, nonatomic) IBOutlet UIView *tdyPriContSep;

@property (weak, nonatomic) IBOutlet UILabel *todayOilPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *todayAllowanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *allowancePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *fareLabel;
@property (weak, nonatomic) IBOutlet UILabel *farePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fareExtraLabel;

@property (weak, nonatomic) IBOutlet UIView *chooseOilCountContainer;
@property (weak, nonatomic) IBOutlet UIView *chsOilCntSepLeft;
@property (weak, nonatomic) IBOutlet UIView *chsOilCntSepRight;
@property (weak, nonatomic) IBOutlet UILabel *chsOilCntLabel;

@property (weak, nonatomic) IBOutlet UITextField *userChoosedOilCntField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIButton *rescueButton;

@property (nonatomic, strong) JXAccount *account;

/** 油种类数组 */
//@property (nonatomic, strong) NSMutableArray *oilKinds;

/** 救援项目价格数组, 从服务器获得 */
@property (nonatomic, strong) NSMutableArray *rescueItems;

/** 油料救援价格数组，从rescueItems分离出来 */
@property (nonatomic, strong) NSMutableArray *oilItems;

@end

@implementation JXRescueDetailViewController
// 起送油量
static NSInteger startCnt = 10;

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
    }
    return _itemList;
}

- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

- (NSMutableArray *)rescueItems {
    if (_rescueItems == nil) {
        _rescueItems = [NSMutableArray array];
    }
    return _rescueItems;
}

- (NSMutableArray *)oilItems {
    if (_oilItems == nil) {
        _oilItems = [NSMutableArray array];
    }
    return _oilItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"救援明细选择";
    self.feeRingView.delegate = self;
    
    [self setBg];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped)];
    [self.contentView addGestureRecognizer:recognizer];
    
    // 请求救援项目油价
    [self loadRescueItems];
}

- (void)setBg {
    // 标尺图片
    UIImage *staffImg = [JXSkinTool skinToolImageWithImageName:@"rescue_staff"];
    /*
     UIImage *resizableStaffImg = [staffImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
     */
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
    
    // 设置背景
    self.bgView.image = [JXSkinTool skinToolImageWithImageName:@"rescue_complete_bg.jpg"];
    // 今日油价container
    self.todayPriceContainer.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_price_container_bg"];
    // 各种titleLabel的字体颜色
    self.todayOilPriceLabel.textColor = self.oilNameLabel.textColor = self.todayAllowanceLabel.textColor = self.fareLabel.textColor = self.fareExtraLabel.textColor = self.chsOilCntLabel.textColor = self.userChoosedOilCntField.textColor = self.unitLabel.textColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_title_text"];
    
    // 各种分割线的颜色
    self.tdyPriContSep.backgroundColor = self.chsOilCntSepLeft.backgroundColor = self.chsOilCntSepRight.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_separator"];
    
    // 救援按钮
    [self.rescueButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_next"] forState:UIControlStateNormal];
    [self.rescueButton setTitleColor:[JXSkinTool skinToolColorWithKey:@"rescue_next"] forState:UIControlStateNormal];
}

- (void)loadRescueItems {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在获取今日油价" toView:self.feeRingView];
    hud.dimBackground = NO;
    hud.color = JXAlphaColor(0, 0, 0, 0);
    UIColor *hudLabelColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_title_text"];
    hud.activityIndicatorColor = hudLabelColor;
    hud.labelColor = hudLabelColor;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"itemType"] = @(1);
    paras[@"origin"] = [NSString stringWithFormat:@"%.6f,%.6f", self.orderDetail.lon, self.orderDetail.lat];
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/orderFee", JXServerName] params:paras success:^(id json) {
        [MBProgressHUD hideHUDForView:self.feeRingView];
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            [self.feeRingView setLoadSuccess:YES message:@"请拖动滑竿选择油料总量"];
            self.corverView.userInteractionEnabled = NO;
            
            self.rescueItems = [JXRescueItem mj_objectArrayWithKeyValuesArray:json[@"data"]];
            
            // 从rescueItems中分离出油料的价格数组
            for (JXRescueItem *item in self.rescueItems) {
                if (item.itemType == 1) {
                    [self.oilItems addObject:item];
                }
            }
            
            [self.oilPickerView reloadAllComponents];
            
            // 设置priceContainer的数据
            if (self.oilItems.count > 0) {
                JXRescueItem *rescueItem = self.oilItems[0];
                [self setDataOfPriceContainerWithrescueItem:rescueItem];
                
                // 设置滑竿最大值
                [self setSliderMaxValueWithRescueItem:rescueItem];
            }
            
        }
        else {
            [self.feeRingView setLoadSuccess:NO message:json[@"msg"]];
            self.corverView.userInteractionEnabled = YES;
        }
        
    } failure:^(NSError *error) {
        JXLog(@"请求失败 - %@", error);
        [MBProgressHUD hideHUDForView:self.feeRingView];
        
        [self.feeRingView setLoadSuccess:NO message:@"获取今日油价失败，点击重新获取"];
    }];
}

- (void)setDataOfPriceContainerWithrescueItem:(JXRescueItem *)rescueItem {
    // 更新油价view显示
    self.oilNameLabel.text = rescueItem.name;
    self.oilPriceLabel.text = [NSString stringWithFormat:@"%.2f元/升", rescueItem.unitPrice];
    self.allowancePriceLabel.text = [NSString stringWithFormat:@"%.2f元/升", rescueItem.subsidy];
    // 计算免运费的升数
    NSInteger fareCnt = rescueItem.sBase*1.8/0.4 + startCnt;
    self.farePriceLabel.text = [NSString stringWithFormat:@"%zd升以上免运费", fareCnt];
}

/**
 *  根据当前选择的油料种类，设置滑竿的最大值
 */
- (void)setSliderMaxValueWithRescueItem:(JXRescueItem *)rescueItem {
    if (rescueItem.itemClass == 0) { // 柴油
        self.slider.maximumValue = 1000;
    }
    else {
        self.slider.maximumValue = 100;
    }
}

- (IBAction)upButtonClicked:(UIButton *)upButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] - 1;

    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
    [self pickerView:self.oilPickerView didSelectRow:selectedRow inComponent:0];
}

- (IBAction)downButtonClicked:(UIButton *)downButton {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] + 1;
    
    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
    [self pickerView:self.oilPickerView didSelectRow:selectedRow inComponent:0];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0];
    JXRescueItem *rescueItem = self.oilItems[selectedRow];
    
    /*
    // 柴油可以精确到1L，汽油精确到10L
    NSInteger itemCnt = 0;
    if (rescueItem.itemClass == -100) { // 柴油
        itemCnt = (NSInteger)(slider.value);
    }
    else { // 汽油
        itemCnt = ((NSInteger)slider.value - ((NSInteger)slider.value % 10));
    }
     */
    
    // 现在改为所有油品都是精确到10L
    NSInteger itemCnt = ((NSInteger)slider.value - ((NSInteger)slider.value % 10));
    
    // 份数
    rescueItem.itemCnt = itemCnt;
    self.userChoosedOilCntField.text = [NSString stringWithFormat:@"%zd", itemCnt];
    
    CGFloat fareFee = rescueItem.sBase*1.8 - (itemCnt-startCnt)*0.4;
    if (fareFee <= 0) {
        fareFee = 0;
    }

    // 项目总价=下单单价*项目数量
    CGFloat oilItemPrice = rescueItem.unitPrice*itemCnt;
    // 补贴
    CGFloat oilAllowanceFee = rescueItem.subsidy * itemCnt;
    // 应付(项目合计)=项目总价+服务费(运费)-补贴金额-红包
    CGFloat oilTotalPrice = oilItemPrice + fareFee - oilAllowanceFee;
    
    // 饼图
    self.feeRingView.allowanceFareOilPrice = oilAllowanceFee + fareFee + oilItemPrice - oilAllowanceFee;
    self.feeRingView.allowanceFee = oilAllowanceFee;
    self.feeRingView.fareFee = fareFee;
    // 应付油款 = 下单单价*项目数量 - 补贴
    self.feeRingView.oilPending = oilItemPrice - oilAllowanceFee;
    self.feeRingView.totalPending = oilTotalPrice;
    // 小计
    self.feeRingView.subtotalFee = oilItemPrice + fareFee;
    
    // 下单时传给服务器的值
    rescueItem.sCharges = fareFee;
    rescueItem.itemPrice = oilItemPrice;
    rescueItem.allowance = oilAllowanceFee;
    rescueItem.totalPrice = oilTotalPrice;
}

- (IBAction)rescueRequestButtonClicked {
    if (self.slider.value == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"油量不能为空" message:@"油量不能为空，请拖动滑动条选择油量哦！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    // 清空用户购买项目
    self.itemList = nil;
    
    // 重新添加购买项目
    NSInteger seletedRow = [self.oilPickerView selectedRowInComponent:0];
    JXRescueItem *selectedItem = self.oilItems[seletedRow];
    JXRescueItem *oilItem = [selectedItem copy];
    // 下单的项目的subsidy要转为优惠总额
    oilItem.subsidy = selectedItem.allowance;
    
    [self.itemList addObject:oilItem];
    
    self.orderDetail.itemList = self.itemList;
    self.orderDetail.totalPrice = oilItem.totalPrice;
    
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
    // 控制向下按钮的enable
    self.downButton.enabled = self.oilItems.count > 1;
    return self.oilItems.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *oilLabel = [[UILabel alloc] init];
    oilLabel.textColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_title_text"];
    oilLabel.font = [UIFont systemFontOfSize:13];
    oilLabel.textAlignment = NSTextAlignmentCenter;

    JXRescueItem *rescueItem = self.oilItems[row];
    oilLabel.text = rescueItem.name;
    return oilLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.upButton.enabled = NO;
    }
    else {
        self.upButton.enabled = YES;
    }
    if (row == self.oilItems.count - 1) {
        self.downButton.enabled = NO;
    }
    else {
        self.downButton.enabled = YES;
    }
    
    JXRescueItem *rescueItem = self.oilItems[row];
    // 设置滑竿最大值
    [self setSliderMaxValueWithRescueItem:rescueItem];
    
    // 重新计算当前油品的价格
    [self sliderValueChanged:self.slider];
    
//    // 设置购买油品种类
//    rescueItem.itemClass = rescueItem.itemClass;
    
    // 设置priceContainer显示
    [self setDataOfPriceContainerWithrescueItem:rescueItem];
    
    switch (row) {
        case 0:
            // 可能要在此处切换油价，重新计算费用
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
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
    
    // 先请求当前是否有未完成的订单
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/findFinishOrder", JXServerName] params:paras success:^(id json) {
        JXLog(@"是否有未完成订单请求成功 - %@", json);
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            BOOL finished = [json[@"data"] boolValue];
            if (finished) { // 所有订单已完成
                [self requestPlaceOrder];
            }
            else { // 有未完成订单
                [MBProgressHUD hideHUD];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"不能提交订单" message:@"您当前还有未完成的订单，不能提交新订单。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:cfmAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }

    } failure:^(NSError *error) {
        JXLog(@"是否有未完成订单请求失败 - %@", error);
        [MBProgressHUD hideHUD];
    }];

}

/**
 *  请求下订单
 */
- (void)requestPlaceOrder {
    // 发送请求
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    NSDictionary *orderDic = [self.orderDetail mj_keyValues];
    
    NSData *orderData = [NSJSONSerialization dataWithJSONObject:orderDic options:0 error:nil];
    NSString *orderStr = [[NSString alloc] initWithData:orderData encoding:NSUTF8StringEncoding];
    paras[@"order"] = orderStr;
    paras[@"origin"] = [NSString stringWithFormat:@"%.6f,%.6f", self.orderDetail.lon, self.orderDetail.lat];
    JXLog(@"下单 - paras = %@", paras);
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
                [JXNotificationCenter postNotificationName:JXPlaceAnOrderNotification object:nil userInfo:@{JXOrderDetailKey:self.orderDetail}];
                
            }];
        }
        else {
            // 下单失败
            [MBProgressHUD showError:json[@"msg"]];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self setSliderValueByUserChooseOilCntFieldNumber];
    
    return YES;
}

- (void)contentViewTapped {
    [self setSliderValueByUserChooseOilCntFieldNumber];
}

/**
 *  通过手动输入的油量来设置滑竿, 继而计算价格
 */
- (void)setSliderValueByUserChooseOilCntFieldNumber {
    [self.slider setValue:[self.userChoosedOilCntField.text floatValue] animated:YES];
    [self sliderValueChanged:self.slider];
    [self.view endEditing:YES];
}

#pragma mark - JXFeeRingViewDelegate
- (void)feeRingViewDidClickedReloadButton {
    [self loadRescueItems];
}


@end
