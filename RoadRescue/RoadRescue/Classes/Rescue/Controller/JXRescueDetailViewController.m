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

@end

@implementation JXRescueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UIImage *staffImg = [UIImage imageNamed:@"rescue_Staff"];
    UIImage *resizableStaffImg = [staffImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.staffView.image = resizableStaffImg;
}

- (IBAction)upButtonClicked {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] - 1;
    if (selectedRow < 0) {
        return;
    }
    [self.oilPickerView selectRow:selectedRow inComponent:0 animated:YES];
}

- (IBAction)downButtonClicked {
    NSInteger selectedRow = [self.oilPickerView selectedRowInComponent:0] + 1;
    if (selectedRow > 3) {
        return;
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
