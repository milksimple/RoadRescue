//
//  JXRescueDetailViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueDetailViewController.h"
#import "JXFeeRingView.h"

@interface JXRescueDetailViewController ()
@property (weak, nonatomic) IBOutlet JXFeeRingView *feeRingView;

@end

@implementation JXRescueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.feeRingView.totalPrice = 2600;
//    self.feeRingView.redBagFee = 200;
//    self.feeRingView.allowanceFee = 600;
//    self.feeRingView.fareFee = 50;
//    self.feeRingView.actuallyPay = 1800-50;
    
    self.feeRingView.totalPrice = 2600;
    self.feeRingView.redBagPercentage = 0.1;
    self.feeRingView.allowancePercentage = 0.2;
    self.feeRingView.fareFee = 0.05;
    self.feeRingView.actuallyPaidPercentage = 0.65;
}

@end
