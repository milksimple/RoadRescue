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
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "JXAccountTool.h"

@interface JXRescueViewController () <UIScrollViewDelegate, AMapLocationManagerDelegate>
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

@property (nonatomic, strong) AMapLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) JXOrderDetail *orderDetail;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *headerSeparator1R;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator1L;
@property (weak, nonatomic) IBOutlet UILabel *chooseAcdTypeLabel;

@property (weak, nonatomic) IBOutlet UIView *headerSeparator2R;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator2L;
@property (weak, nonatomic) IBOutlet UILabel *rescueAddressLabel;

@property (weak, nonatomic) IBOutlet UIView *headerSeparator3R;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator3L;
@property (weak, nonatomic) IBOutlet UILabel *chooseSerItemLabel;

@property (weak, nonatomic) IBOutlet UIView *chooseAcdTypeContentView;
@property (weak, nonatomic) IBOutlet UIView *addressContainer;

@property (weak, nonatomic) IBOutlet UIView *chooseAcdContSeparator;
@property (weak, nonatomic) IBOutlet UIButton *chooseAcdContButton;

@property (weak, nonatomic) IBOutlet UIImageView *rescueAddressLocationView;

@property (nonatomic, strong) JXAccount *account;
@end

@implementation JXRescueViewController
#pragma mark - lazy
- (AMapLocationManager *)locMgr {
    if (_locMgr == nil) {
        _locMgr = [[AMapLocationManager alloc] init];
        [_locMgr setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为3s
        _locMgr.locationTimeout =3;
        //   逆地理请求超时时间，最低2s，此处设置为3s
        _locMgr.reGeocodeTimeout = 3;
        
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

- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.accidentDesView.placeholder = @"添加详细事故描述（可选，最多128个字）";
    self.accidentDesView.placeholderColor = [UIColor blackColor];
    
    // 定位
    [self setupLocation];
    
    // 导航栏背景
    UIImage *navBgImg = [JXSkinTool skinToolImageWithImageName:@"rescue_nav_bg"];
    // 这尼玛还要来个特殊处理？
    if (navBgImg == nil) {
        navBgImg = [UIImage new];
    }
    [self.navigationController.navigationBar setBackgroundImage:navBgImg forBarMetrics:UIBarMetricsDefault];
    
    // 设置背景
    self.bgView.image = [JXSkinTool skinToolImageWithImageName:@"rescue_complete_bg.jpg"];
    // 分割线的颜色
    self.headerSeparator1R.backgroundColor = self.headerSeparator1L.backgroundColor = self.headerSeparator2R.backgroundColor = self.headerSeparator2L.backgroundColor = self.headerSeparator3R.backgroundColor = self.headerSeparator3L.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_separator"];
    
    
    // header里面label背景色
//    self.chooseAcdTypeLabel.backgroundColor = self.rescueAddressLabel.backgroundColor = self.chooseSerItemLabel.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_label_bg"];
    
    
    // header里面label字体颜色
    self.chooseAcdTypeLabel.textColor = self.rescueAddressLabel.textColor = self.chooseSerItemLabel.textColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_label_text"];
    
    // content背景色
    self.chooseAcdTypeContentView.backgroundColor = self.addressContainer.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_content_bg"];
    
    // content内部字体颜色
    self.accidentypeField.textColor = self.addressShortLabel.textColor = self.addressDesLabel.textColor = [JXSkinTool skinToolColorWithKey:@"rescue_content_text"];
    self.chooseAcdContSeparator.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_content_separator"];
    
    [self.chooseAcdContButton setImage:[JXSkinTool skinToolImageWithImageName:@"triangle_down"] forState:UIControlStateNormal];
    self.rescueAddressLocationView.image = [JXSkinTool skinToolImageWithImageName:@"location"];
    
    // 下一步按钮
    [self.nextButton setBackgroundImage:[JXSkinTool skinToolImageWithImageName:@"rescue_next"] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[JXSkinTool skinToolColorWithKey:@"rescue_next"] forState:UIControlStateNormal];
}

- (void)setupNav {
    self.navigationItem.title = @"发布救援申请";
    
    UIColor *titleColor = [JXSkinTool skinToolColorWithKey:@"rescue_nav_title"];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent64"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [JXSkinTool skinToolColorWithKey:@"rescue_nav_barTint"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
}

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
    
    [self.locMgr startUpdatingLocation];
}

/**
 *  点击了下一步
 */
- (IBAction)nextButtonClicked {    
    if (self.orderDetail.lon == 0 || self.orderDetail.lat == 0) { // 没有定位到
        // 提示没有定位到
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    if (self.accidentDesView.text.length > 128) {
        // 提示字符过长
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"超过128个字" message:@"您的事故描述字数过多，请简化描述" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
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
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择服务项目" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    self.orderDetail.orderer = self.account.telephone;
    self.orderDetail.accidentDes = self.accidentDesView.text;
    self.orderDetail.addressShort = self.addressShortLabel.text;
    self.orderDetail.addressDes = self.addressDesLabel.text;
    
    JXRescueDetailViewController *rescueDetailVC = [[JXRescueDetailViewController alloc] initWithOrderDetail:self.orderDetail];
    [self.navigationController pushViewController:rescueDetailVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    // 赶紧停止定位
    [self.locMgr stopUpdatingLocation];
    
    self.orderDetail.lon = location.coordinate.longitude;
    self.orderDetail.lat = location.coordinate.latitude;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的YES改成NO，则不会返回地址信息。
    [self.locMgr requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            JXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            self.addressShortLabel.text = @"未获取到详细位置信息";
            self.addressDesLabel.text = @"未获取到详细位置信息";
        }
        JXLog(@"location:%@", location);
        
        if (regeocode)
        {
            JXLog(@"reGeocode:%@", regeocode);
            self.addressShortLabel.text = regeocode.AOIName;
            if (self.addressShortLabel.text.length == 0) {
                self.addressShortLabel.text = [NSString stringWithFormat:@"%@%@", regeocode.street, regeocode.number];
            }
            if (self.addressShortLabel.text.length == 0) {
                self.addressShortLabel.text = @"未获取到详细位置信息";
            }
            
            self.addressDesLabel.text = regeocode.formattedAddress;
            if (self.addressDesLabel.text.length == 0) {
                self.addressDesLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", regeocode.province, regeocode.city, regeocode.district, regeocode.street, regeocode.number];
            }
            if (self.addressDesLabel.text.length == 0) {
                self.addressDesLabel.text = @"未获取到详细位置信息";
            }
            
        }
    }];
}


@end
