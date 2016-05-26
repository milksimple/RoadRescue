//
//  JXRescueDetailViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueDetailViewController.h"
#import "JXFeeRingView.h"
#import "JXRescueDetailPopView.h"

@interface JXRescueDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet JXFeeRingView *feeRingView;
@property (weak, nonatomic) IBOutlet UIPickerView *oilPickerView;
@property (weak, nonatomic) IBOutlet UIImageView *staffView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation JXRescueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"救援明细选择";
    
    self.feeRingView.totalPrice = 2600;
    self.feeRingView.redBagFee = 200;
    self.feeRingView.allowanceFee = 600;
    self.feeRingView.fareFee = 50;
    self.feeRingView.actuallyPay = 1800-50;
    
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

- (IBAction)rescueRequestButtonClicked {
    JXRescueDetailPopView *rescueDetailPopView = [JXRescueDetailPopView popView];
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
            oilLabel.text = @"93#汽油";
            break;
            
        case 1:
            oilLabel.text = @"95#汽油";
            break;
            
        case 2:
            oilLabel.text = @"97#汽油";
            break;
            
        case 3:
            oilLabel.text = @"柴油";
            break;
    }
    return oilLabel;
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

//}

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
