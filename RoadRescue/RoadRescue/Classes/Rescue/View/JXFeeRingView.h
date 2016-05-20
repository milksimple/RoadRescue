//
//  JXFeeRingView.h
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//  费用百分比圆环

#import <UIKit/UIKit.h>

@interface JXFeeRingView : UIView

+ (instancetype)feeRingViewWithTotalPrice:(NSInteger)totalPrice redBagFee:(NSInteger)redBagFee allowanceFee:(NSInteger)allowanceFee fareFee:(NSInteger)fareFee actuallyPay:(NSInteger)actuallyPay;

/** 红包返利 */
@property (nonatomic, assign) NSInteger redBagFee;
/** 优惠补贴 */
@property (nonatomic, assign) NSInteger allowanceFee;
/** 运费 */
@property (nonatomic, assign) NSInteger fareFee;
/** 待付油款 */
@property (nonatomic, assign) NSInteger actuallyPay;
/** 总价 */
@property (nonatomic, assign) NSInteger totalPrice;

- (void)redraw;

/** 是否免运费 */
@property (nonatomic, assign, getter=isFreeFare) BOOL freeFare;

/** 红包占总额比 */
@property (nonatomic, assign) CGFloat redBagPercentage;
/** 优惠占总额比 */
@property (nonatomic, assign) CGFloat allowancePercentage;
/** 运费占总额比 */
@property (nonatomic, assign) CGFloat farePercentage;
/** 实付占总额比 */
@property (nonatomic, assign) CGFloat actuallyPaidPercentage;

@end
