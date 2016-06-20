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
    self.bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    // 分割线的颜色
    self.headerSeparator1R.backgroundColor = self.headerSeparator1L.backgroundColor = self.headerSeparator2R.backgroundColor = self.headerSeparator2L.backgroundColor = self.headerSeparator3R.backgroundColor = self.headerSeparator3L.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_separator"];
    // header里面label背景色
    self.chooseAcdTypeLabel.backgroundColor = self.rescueAddressLabel.backgroundColor = self.chooseSerItemLabel.backgroundColor = [JXSkinTool skinToolColorWithKey:@"rescue_header_label_bg"];
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
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent64"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [JXSkinTool skinToolColorWithKey:@"rescue_nav_barTint"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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
    if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locMgr requestWhenInUseAuthorization];
        
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locMgr startUpdatingLocation];
        }
        else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:cfmAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

/**
 *  点击了下一步
 */
- (IBAction)nextButtonClicked {    
    if (self.orderDetail.lon == 0 || self.orderDetail.lat == 0) { // 没有定位到
        // 提示没有定位到
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
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
    
#warning 测试数据
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
            
            NSString *thoroughfare = placemark.thoroughfare.length == 0 ? @"" : placemark.thoroughfare;
            NSString *subThoroughfare = placemark.subThoroughfare.length == 0 ? @"" : placemark.subThoroughfare;
            NSString *locality = placemark.locality.length == 0 ? @"" : placemark.locality;
            NSString *subLocality = placemark.subLocality.length == 0 ? @"" : placemark.subLocality;
            self.addressShortLabel.text = [NSString stringWithFormat:@"%@%@", thoroughfare, subThoroughfare];
            if (self.addressShortLabel.text.length == 0) {
                self.addressShortLabel.text = placemark.name;
            }
            if (self.addressShortLabel.text.length == 0) {
                self.addressShortLabel.text = @"未获取到详细位置信息";
            }
            
            self.addressDesLabel.text = [NSString stringWithFormat:@"%@ %@%@%@", locality, subLocality, thoroughfare, subThoroughfare];
            if (self.addressDesLabel.text.length == 0) {
                self.addressDesLabel.text = self.addressShortLabel.text = placemark.name;
            }
            if (self.addressDesLabel.text.length == 0) {
                self.addressDesLabel.text = @"未获取到详细位置信息";
            }
            
//            JXLog(@"placemark.addressDictionary = %@", placemark.addressDictionary);
//            JXLog(@"areasOfInterest = %@", placemark.areasOfInterest);
//            JXLog(@"name = %@, thoroughfare = %@, subThoroughfare= %@, locality = %@, subLocality = %@ administrativeArea = %@", placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.subLocality, placemark.administrativeArea);
        }
    }];
}


@end
