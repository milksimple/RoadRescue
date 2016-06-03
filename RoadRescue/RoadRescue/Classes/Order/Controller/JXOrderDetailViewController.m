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

@interface JXOrderDetailViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *rescueDesLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *oilImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilNameAndCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *rescueNumLabel;

@property (nonatomic, strong) JXOrderDetail *orderDetail;

@property (nonatomic, strong) JXAnnotation *annotation;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"moblie"] = @"13888650223";
    paras[@"token"] = @"7F9D459A";
    paras[@"orderNum"] = self.orderNum;
    JXLog(@"orderNum = %@", self.orderNum);
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
    switch (rescueItem.itemClass) {
        case 0: // 柴油
            self.oilNameAndCntLabel.text = [NSString stringWithFormat:@"%@ %zdL", @"柴油", rescueItem.itemCnt];
            break;
            
        case 93:
            self.oilNameAndCntLabel.text = [NSString stringWithFormat:@"%@ %zdL", @"93#汽油", rescueItem.itemCnt];
            break;
            
        case 97:
            self.oilNameAndCntLabel.text = [NSString stringWithFormat:@"%@ %zdL", @"97#汽油", rescueItem.itemCnt];
            break;
            
        default:
            break;
    }
    
    // 时间
    self.timeLabel.text = orderDetail.title;
    // 地点
    [self.addressButton setTitle:orderDetail.addressDes forState:UIControlStateNormal];
    // 救援描述
    self.rescueDesLabel.text = orderDetail.accidentDes;
    // 总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%f", orderDetail.totalPrice];
    // 救援指数
    self.rescueNumLabel.text = [NSString stringWithFormat:@"%zd", orderDetail.rescueIndex];
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
}

/**
 *  联系客户被点击
 */
- (IBAction)contactButtonClicked {
    
}


//#pragma mark - MKMapViewDelegate
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    JXLog(@"region -- lon = %f, lat = %f, span -- lon = %f, lat = %f", mapView.region.center.longitude, mapView.region.center.latitude, mapView.region.span.longitudeDelta, mapView.region.span.latitudeDelta);
//}

@end
