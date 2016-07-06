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

@interface JXOrderDetailViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;

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

@end

@implementation JXOrderDetailViewController

- (instancetype)initWithOrderNum:(NSString *)orderNum {
    if (self = [super init]) {
        self.orderNum = orderNum;
    }
    return self;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    // 设置wave背景图
    UIImage *waveBgImg = [JXSkinTool skinToolImageWithImageName:@"order_wave_bg"];
    UIImage *resizableImg = [waveBgImg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 10, 0) resizingMode:UIImageResizingModeTile];
    self.waveBgView.image = resizableImg;
    
    [self loadData];
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
    paras[@"orderNum"] = self.orderNum;
    paras[@"orderType"] = @1;

    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/findOrder", JXServerName] params:paras success:^(id json) {
        JXLog(@"请求成功 - %@", json);
        self.orderDetail = [JXOrderDetail mj_objectWithKeyValues:json[@"data"]];
        [self setControlsWithOrderDetail:self.orderDetail];
    } failure:^(NSError *error) {
        JXLog(@"请求失败 - %@", error);
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
    [self.addressButton setTitle:orderDetail.addressDes forState:UIControlStateNormal];
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
    
    NSString *cancelBtnTitle = self.orderDetail.orderStatus == 0 ? @"取消订单" : @"联系客服";
    [self.cancelButton setTitle:cancelBtnTitle forState:UIControlStateNormal];
}

/**
 *  取消被点击
 */
- (IBAction)cancelOrderButtonClicked:(UIButton *)cancelBtn {
    // 点击了联系客服
    if ([cancelBtn.titleLabel.text isEqualToString:@"联系客服"]) {
        // 拨打电话按钮被点击
        NSString *str= [NSString stringWithFormat:@"tel:%@", self.orderDetail.mobile];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        return;
    }
    
    // 点击了取消订单
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"]= self.account.token;
    paras[@"orderNum"] = self.orderNum;
    JXLog(@"paras = %@", paras);
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/removeOrder", JXServerName] params:paras success:^(id json) {
        JXLog(@"取消订单成功 - %@", json);
        BOOL success = [json[@"success"] boolValue];
        if (success) { // 取消成功
            [JXNotificationCenter postNotificationName:JXCancelAnOrderNotification object:@{JXCancelOrderDetailKey:self.orderDetail}];
        }
        else {
            [MBProgressHUD showError:json[@"msg"]];
            
            // 重新请求服务器，刷新订单状态
            [self loadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败"];
        JXLog(@"取消订单失败 - %@", error);
    }];
}

- (void)dealloc {
    JXLog(@"JXOrderDetailViewController - dealloc");
}

//#pragma mark - MKMapViewDelegate
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    JXLog(@"region -- lon = %f, lat = %f, span -- lon = %f, lat = %f", mapView.region.center.longitude, mapView.region.center.latitude, mapView.region.span.longitudeDelta, mapView.region.span.latitudeDelta);
//}

@end
