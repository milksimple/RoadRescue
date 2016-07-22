//
//  JXOrderDetailViewController.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrderDetailViewController.h"
#import <MapKit/MapKit.h>
#import "JXAnnotation.h"
#import "JXHttpTool.h"
#import "JXOrderDetail.h"
#import <MJExtension.h>
#import "UIView+JXExtension.h"
#import "JXAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "JXMyOrderCompletePopView.h"

@interface JXOrderDetailViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *rescueDesLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *oilImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilNameAndCntLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) JXOrderDetail *orderDetail;

@property (nonatomic, strong) JXAnnotation *annotation;

@property (nonatomic, strong) JXAccount *account;

@property (nonatomic, weak) JXMyOrderCompletePopView *completePopView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rescueDesLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation JXOrderDetailViewController
#pragma mark - lazy
- (JXAnnotation *)annotation {
    if (_annotation == nil) {
        _annotation = [[JXAnnotation alloc] init];
    }
    return _annotation;
}

- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

- (JXMyOrderCompletePopView *)completePopView {
    if (_completePopView == nil) {
        _completePopView = [JXMyOrderCompletePopView completePopView];
    }
    return _completePopView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.addressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self setBg];
    
    // 先用从列表得到的orderDetail设置
    [self setControlsWithOrderDetail:self.defaultOrderDetail];
    
    [self loadData];
    
    // 监听成功完成订单的通知
    [JXNotificationCenter addObserver:self selector:@selector(orderSuccessFinished:) name:JXOrderSuccessFinishedNotification object:nil];
}

- (void)setBg {
    // 位置按钮
    [self.addressButton setImage:[JXSkinTool skinToolImageWithImageName:@"location"] forState:UIControlStateNormal];
    // 设置top背景图
    self.topBgView.image = [JXSkinTool skinToolImageWithImageName:@"order_detail_top"];
    // 设置wave背景图
    self.waveBgView.image = [JXSkinTool skinToolImageWithImageName:@"order_detail_wave"];
    
    self.bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
}

#pragma mark - 内容不够一个屏幕高度，scrollview也能滚动
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.contentView.jx_height <= self.view.jx_height - 64) {
        self.scrollView.contentSize = CGSizeMake(JXScreenW, JXScreenH - 64 + 1);
    }
}
*/

- (void)loadData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"orderNum"] = self.defaultOrderDetail.orderNum;
    paras[@"orderType"] = @1;

    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/findOrder", JXServerName] params:paras success:^(id json) {
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            self.orderDetail = [JXOrderDetail mj_objectWithKeyValues:json[@"data"]];
            self.orderDetail.title = self.defaultOrderDetail.title;
            [self setControlsWithOrderDetail:self.orderDetail];
        }
        
    } failure:^(NSError *error) {
        JXLog(@"请求订单详情失败 - %@", error);
    }];
}

/**
 *  给各个控件赋值
 */
- (void)setControlsWithOrderDetail:(JXOrderDetail *)orderDetail {
    if (orderDetail.itemList.count == 0) return;
    
    JXRescueItem *rescueItem = orderDetail.itemList[0];
    
    switch (orderDetail.itemTypes) {
        case 1: // 油料救援
            self.titleLabel.text = @"燃油耗尽";
            break;
            
        case 2: // 简易维修
            
            break;
            
        case 3: // 油料救援 + 简易维修
            
            break;
            
        default:
            break;
    }
    
    // 汽油种类
    if (rescueItem.itemClass == 0) {
        self.oilNameAndCntLabel.text = [NSString stringWithFormat:@"%@ %zdL", @"柴油", rescueItem.itemCnt];
    }
    else {
        self.oilNameAndCntLabel.text = [NSString stringWithFormat:@"%zd#汽油 %zdL", rescueItem.itemClass, rescueItem.itemCnt];
    }
    
    // 时间
    self.timeLabel.text = orderDetail.title;
    // 地点
    self.addressLabel.text = orderDetail.addressDes;
//    [self.addressButton setTitle: forState:UIControlStateNormal];
    // 设置救援描述高度
    CGRect rect = [self.rescueDesLabel.text boundingRectWithSize:CGSizeMake(JXScreenW - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.rescueDesLabelHeightConstraint.constant = rect.size.height;
    // 救援描述
    self.rescueDesLabel.text = orderDetail.accidentDes;
    
    // 总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", orderDetail.totalPrice];
    // 地图
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(orderDetail.lat, orderDetail.lon);
    self.annotation.coordinate = centerCoordinate;
    [self.mapView addAnnotation:self.annotation];
    
    // 设置中心点
    [self.mapView setCenterCoordinate:centerCoordinate animated:YES];
    
    // 设置跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    NSString *cancelBtnTitle = nil;
    NSString *cancelBtnBgImg = nil;
    /** 救援状态<-1-订单已取消,  0-已下单,1-已接单,2-完成等待付款,9-完成> */
    if (orderDetail.orderStatus == -1 || orderDetail.orderStatus == 9) {
        self.cancelButton.userInteractionEnabled = NO;
    }
    else {
        self.cancelButton.userInteractionEnabled = YES;
    }
    switch (orderDetail.orderStatus) {
        case -1:
            cancelBtnTitle = @"订单已取消";
            cancelBtnBgImg = @"order_see_button_gray";
            break;
            
        case 0:
            cancelBtnTitle = @"取消订单";
            cancelBtnBgImg = @"order_see_button_orange";
            break;
            
        case 1:
            cancelBtnTitle = @"联系客服";
            cancelBtnBgImg = @"order_see_button_orange";
            break;
            
        case 2:
            cancelBtnTitle = @"确认完成";
            cancelBtnBgImg = @"order_see_button_orange";
            break;
            
        case 9:
            cancelBtnTitle = @"已完成";
            cancelBtnBgImg = @"order_see_button_gray";
            break;
            
        default:
            break;
    }
    [self.cancelButton setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:cancelBtnBgImg] forState:UIControlStateNormal];
}

/**
 *  取消被点击
 */
- (IBAction)cancelOrderButtonClicked:(UIButton *)cancelBtn {
    switch (self.orderDetail.orderStatus) {
        case -1: // 订单已取消
            
            break;
            
        case 0: { // 已下单
            MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在取消订单"];
            hud.mode = MBProgressHUDModeIndeterminate;
            // 点击了取消订单
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            paras[@"mobile"] = self.account.telephone;
            paras[@"token"]= self.account.token;
            paras[@"orderNum"] = self.orderDetail.orderNum;
            JXLog(@"paras = %@", paras);
            [JXHttpTool post:[NSString stringWithFormat:@"%@/order/removeOrder", JXServerName] params:paras success:^(id json) {
                JXLog(@"取消订单成功 - %@", json);
                [MBProgressHUD hideHUD];
                BOOL success = [json[@"success"] boolValue];
                if (success) { // 取消成功
                    [MBProgressHUD showSuccess:@"取消成功！"];
                    [JXNotificationCenter postNotificationName:JXCancelAnOrderNotification object:nil userInfo:@{JXCancelOrderDetailKey:self.orderDetail}];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [MBProgressHUD showError:json[@"msg"]];
                    
                    // 重新请求服务器，刷新订单状态
                    [self loadData];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络连接失败"];
                JXLog(@"取消订单失败 - %@", error);
            }];
            break;
        }
            
        case 1: { // 已接单
            // 拨打电话按钮被点击
            NSString *str= [NSString stringWithFormat:@"tel:%@", self.orderDetail.mobile];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            break;
        }
            
        case 2: { // 完成等待付款
            self.completePopView.orderDetail = self.orderDetail;
            [self.completePopView show];
            break;
        }
            
        case 9: { // 已完成
            
            break;
        }
            
        default:
            break;
    }
    
    
}

#pragma mark - JXOrderSuccessFinishedNotification
- (void)orderSuccessFinished:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXOrderDetailKey];
    if ([self.orderDetail.orderNum isEqualToString:orderDetail.orderNum]) {
        self.orderDetail.orderStatus = 9;
        [self setControlsWithOrderDetail:self.orderDetail];
        
        return;
    }
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}
//#pragma mark - MKMapViewDelegate
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    JXLog(@"region -- lon = %f, lat = %f, span -- lon = %f, lat = %f", mapView.region.center.longitude, mapView.region.center.latitude, mapView.region.span.longitudeDelta, mapView.region.span.latitudeDelta);
//}

@end
