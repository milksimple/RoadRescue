//
//  JXRescueViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//
/** name = 金尚俊园C座, thoroughfare = 小坝路2, subThoroughfare= (null), locality = 昆明市, subLocality = 盘龙区 administrativeArea = 云南省 */


#import "JXRescueViewController.h"
#import "JXVerticalButton.h"
#import "UIView+JXExtension.h"
#import "JXTextView.h"
#import "JXRescueDetailViewController.h"
#import "JXOrderDetail.h"
#import <CoreLocation/CoreLocation.h>

@interface JXRescueViewController () <UIScrollViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet JXTextView *accidentDesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *accidentypeField;
@property (weak, nonatomic) IBOutlet UILabel *addressShortLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDesLabel;
@property (weak, nonatomic) IBOutlet JXVerticalButton *oilButton;
@property (weak, nonatomic) IBOutlet JXVerticalButton *fixButton;

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) JXOrderDetail *orderDetail;

@end

@implementation JXRescueViewController
#pragma mark - lazy
- (CLLocationManager *)locMgr {
    if (_locMgr == nil) {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
    }
    return _locMgr;
}

- (JXOrderDetail *)orderDetail {
    if (_orderDetail == nil) {
        _orderDetail = [[JXOrderDetail alloc] init];
    }
    return _orderDetail;
}

- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.accidentDesView.placeholder = @"添加详细事故描述（可选）";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 定位
    [self setupLocation];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    CGFloat currentMaxY = CGRectGetMaxY(self.nextButton.frame) + 20;
//    if (currentMaxY < JXScreenH) {
//        //        self.contentViewBottomConstraint.constant = JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame) + 20;
//        //
//        //        JXLog(@"%f  %f", self.contentView.frame.size.height, JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame));
//        //        [self.view layoutIfNeeded];
//        self.nextButtonTopConstraint.constant = 200;
//    }
//    
//    
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    CGFloat currentMaxY = CGRectGetMaxY(self.nextButton.frame) + 20;
//    if (currentMaxY < JXScreenH) {
////        self.contentViewBottomConstraint.constant = JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame) + 20;
////        
////        JXLog(@"%f  %f", self.contentView.frame.size.height, JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame));
////        [self.view layoutIfNeeded];
//        self.nextButtonTopConstraint.constant = 200;
//    }
//}

- (void)setupNav {
    self.navigationItem.title = @"发布救援申请";
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationController.navigationBar.barTintColor = JXMiOrangeColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor bla]}];
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)oilButtonClicked:(JXVerticalButton *)sender {
    sender.selected = !sender.isSelected;
    
}

- (IBAction)fixButtonClicked:(JXVerticalButton *)sender {
    sender.selected = !sender.isSelected;
    
}

- (void)setupLocation {
    if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locMgr requestWhenInUseAuthorization];
        
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locMgr startUpdatingLocation];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/**
 *  点击了下一步
 */
- (IBAction)nextButtonClicked {    
    if (self.orderDetail.lon == 0 || self.orderDetail.lat == 0) { // 没有定位到
        // 提示没有定位到
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有定位到您的位置" message:@"还没有定位到您的位置，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.oilButton.selected == YES && self.fixButton.selected == NO) { // 油料救援
        self.orderDetail.itemTypes = 1;
    }
    else if (self.oilButton.selected == NO && self.fixButton.selected == YES) { // 简易维修
        self.orderDetail.itemTypes = 2;
    }
    else if (self.oilButton.selected == YES && self.fixButton.selected == YES) { // 油料救援 + 简易维修
        self.orderDetail.itemTypes = 3;
    }
    else { // 没有选择任何项目
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择服务项目" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.orderDetail.orderer = @"13888650223";
    self.orderDetail.accidentDes = self.accidentDesView.text;
    self.orderDetail.addressShort = self.addressShortLabel.text;
    self.orderDetail.addressDes = self.addressDesLabel.text;
    
    JXRescueDetailViewController *rescueDetailVC = [[JXRescueDetailViewController alloc] initWithOrderDetail:self.orderDetail];
    [self.navigationController pushViewController:rescueDetailVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    JXLog(@"touchesBegan");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *location = locations.firstObject;
    self.orderDetail.lon = location.coordinate.longitude;
    self.orderDetail.lat = location.coordinate.latitude;
    
    // 反地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = placemarks.firstObject;
            self.addressShortLabel.text = [NSString stringWithFormat:@"%@%@", placemark.thoroughfare, placemark.subThoroughfare];
            self.addressDesLabel.text = [NSString stringWithFormat:@"%@ %@%@%@", placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare];
            
            JXLog(@"placemark.addressDictionary = %@", placemark.addressDictionary);
            JXLog(@"areasOfInterest = %@", placemark.areasOfInterest);
            JXLog(@"name = %@, thoroughfare = %@, subThoroughfare= %@, locality = %@, subLocality = %@ administrativeArea = %@", placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.subLocality, placemark.administrativeArea);
        }
    }];
}


@end
